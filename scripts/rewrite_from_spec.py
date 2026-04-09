#!/usr/bin/env python3
"""Rewrite BashMissions level content from a spec file."""
from __future__ import annotations

import ast
import json
import os
import re
import shutil
import sys
from dataclasses import dataclass, field
from pathlib import Path

import yaml

REPO_ROOT = Path(__file__).resolve().parent.parent
MODULES_DIR = REPO_ROOT / "modules"
LEVELS_JSON = REPO_ROOT / "levels.json"

MODULE_RE = re.compile(r"^## MODULE (\d+) — (.+?)(?: \(levels .*?\))?$")
BASE_DIR_RE = re.compile(r"^Base dir: ([^/]+)/$")
LEVEL_RE = re.compile(r"^level-(\d+)-([a-z0-9-]+) \(id:(\d+)\)$")
MODULE_RANGE_RE = re.compile(r"modules (\d+)-(\d+) \(levels (\d+)-(\d+)\)")
FIXTURE_INLINE_RE = re.compile(r'fixture ([^:]+): "([^"]*)"')
TEST_ARGS_RE = re.compile(r"args:(\[[^\]]*\])")
EXIT_RE = re.compile(r"exit:(\d+)|expected_exit:(\d+)")
EXPECTED_RE = re.compile(r'expected_stdout:"(.*)"')


@dataclass
class ModuleMeta:
    number: int
    display: str
    base_dir: str = ""
    difficulty: str = "intermediate"
    xp_min: int = 100
    xp_max: int = 150
    scaffold: bool = False


def defaults_for_spec(spec_name: str, module_number: int) -> tuple[str, int, int, bool]:
    mapping = {
        "6-10": {
            (6, 8): ("beginner", 80, 120, True),
            (9, 10): ("intermediate", 100, 150, False),
        },
        "11-15": {
            (11, 13): ("intermediate", 130, 180, False),
            (14, 15): ("advanced", 180, 250, False),
        },
        "16-20": {
            (16, 20): ("advanced", 200, 350, False),
        },
        "21-26": {
            (21, 24): ("advanced", 250, 350, False),
            (25, 26): ("expert", 350, 500, False),
        },
    }
    for (start, end), values in mapping.get(spec_name, {}).items():
        if start <= module_number <= end:
            return values
    return "intermediate", 100, 150, False


@dataclass
class LevelSpec:
    id: int
    slug: str
    title: str
    module: ModuleMeta
    concept: str = ""
    objective_lines: list[str] = field(default_factory=list)
    tests: list[dict] = field(default_factory=list)
    fixtures: list[str] = field(default_factory=list)
    fixture_data: dict[str, str] = field(default_factory=dict)
    fixture_modes: dict[str, int] = field(default_factory=dict)


def load_titles() -> dict[int, str]:
    return {
        int(item["id"]): item["title"]
        for item in json.loads(LEVELS_JSON.read_text(encoding="utf-8"))
    }


def decode_escaped(text: str) -> str:
    return bytes(text, "utf-8").decode("unicode_escape")


def parse_args(text: str) -> list[str]:
    return ast.literal_eval(text)


def parse_test_line(line: str) -> dict | None:
    args_match = TEST_ARGS_RE.search(line)
    if not args_match:
        return None
    args = parse_args(args_match.group(1))
    comparison = "exact"
    if "comparison:contains" in line:
        comparison = "contains"
    elif "comparison:regex" in line:
        comparison = "regex"
    elif "comparison:ignore_whitespace" in line:
        comparison = "ignore_whitespace"

    expected_exit = 0
    exit_match = EXIT_RE.search(line)
    if exit_match:
        expected_exit = int(exit_match.group(1) or exit_match.group(2))

    expected_stdout = ""
    stdout_match = EXPECTED_RE.search(line)
    if stdout_match:
        expected_stdout = decode_escaped(stdout_match.group(1))
    elif "→" in line:
        rhs = line.split("→", 1)[1].strip()
        quoted = re.search(r'"(.*)"', rhs)
        if quoted:
            expected_stdout = decode_escaped(quoted.group(1))

    return {
        "args": args,
        "expected_stdout": expected_stdout,
        "expected_exit": expected_exit,
        "comparison": comparison,
    }


def parse_range(text: str) -> tuple[int, int]:
    match = re.search(r"xp:\s*(\d+)-(\d+)", text)
    if not match:
        return 100, 150
    return int(match.group(1)), int(match.group(2))


def choose_xp(level_id: int, low: int, high: int) -> int:
    if low >= high:
        return low
    span = high - low
    step = max(1, span // 5)
    value = low + ((level_id - 1) % 6) * step
    return min(value, high)


def parse_concepts(raw: str) -> list[str]:
    parts = re.split(r",| and | \+ | / ", raw)
    concepts = []
    for part in parts:
        cleaned = part.strip().lower()
        if cleaned:
            concepts.append(re.sub(r"[^a-z0-9]+", "-", cleaned).strip("-"))
    return concepts[:4] or ["bash"]


def clean_objective_lines(lines: list[str]) -> list[str]:
    cleaned = []
    skip_prefixes = (
        "Test:",
        "fixture ",
        "fixtures:",
        "difficulty:",
        "comparison:",
        "Start immediately.",
        "Actually:",
        "Better approach:",
        "Simpler:",
        "Approach:",
        "Or simpler:",
        "Simplest",
        "Use:",
        "Since ",
        "---",
    )
    for line in lines:
        stripped = line.strip()
        if not stripped:
            continue
        if stripped.startswith(skip_prefixes):
            continue
        if stripped.startswith("(") and stripped.endswith(")"):
            continue
        cleaned.append(stripped)
    return cleaned


def default_objective(level: LevelSpec) -> str:
    lines = clean_objective_lines(level.objective_lines)
    if lines:
        return " ".join(lines)
    if level.tests:
        sample = level.tests[0]
        args = ", ".join(repr(arg) for arg in sample["args"])
        return (
            f"Write `solution.sh` for `{level.title}` using {level.concept}. "
            f"When run with [{args}], it must produce the exact expected output."
        )
    return f"Write `solution.sh` for `{level.title}` using {level.concept}."


def hint_from_concept(concept: str, level_id: int) -> str:
    c = concept.lower()
    pairs = [
        ("function", "Define the function first, then call it with the right arguments."),
        ("return", "Use `return` for exit status and `echo` when you need to return text."),
        ("local", "Inside a function, `local` keeps temporary variables from leaking into the global scope."),
        ("regex", "Use `[[ value =~ pattern ]]` and inspect `BASH_REMATCH` for captured groups."),
        ("array", "Arrays use `${arr[@]}`, `${#arr[@]}`, and `${arr[index]}` depending on what you need."),
        ("mapfile", "Use `mapfile -t arr < file` or process substitution to load lines into an array."),
        ("redirect", "Redirections like `>`, `2>`, and `2>&1` change where command output goes."),
        ("pipe", "Pipelines connect stdout from one command to stdin of the next command."),
        ("trap", "Set the trap before the event you want to catch."),
        ("set -", "Shell options like `set -e`, `set -u`, and `set -o pipefail` change script behavior globally."),
        ("awk", "Keep the awk program small and focused on exactly the field or condition the mission asks for."),
        ("sed", "Write the sed expression first, then test it against the exact fixture content."),
        ("find", "Use `find` when the mission is about files, patterns, or traversal rather than shell globs alone."),
        ("printf", "Use `printf` when exact formatting matters."),
        ("process", "Capture the PID or output you need immediately so the next step uses the right job."),
        ("config", "Parse the config into variables first, then validate or print exactly what the mission requires."),
        ("security", "Prefer the safe shell pattern the mission names instead of a shortcut that only looks similar."),
        ("curl", "Build the command defensively and handle the success and failure path explicitly."),
        ("jq", "Use `jq -r` when you need clean text output from JSON."),
        ("flock", "Acquire the lock, do the work, then release it cleanly."),
    ]
    for key, value in pairs:
        if key in c:
            return value
    return f"This level is about {concept}. Use that feature directly in the script instead of solving it with a shortcut."


def snippet_for_level(level: LevelSpec) -> str:
    test = level.tests[0] if level.tests else {"args": [], "expected_stdout": ""}
    concept = level.concept.lower()
    if "function" in concept:
        return "my_fn() {\n  # TODO: implement\n}\n\nmy_fn \"$@\""
    if "regex" in concept:
        return "if [[ \"$1\" =~ PATTERN ]]; then\n  echo \"match\"\nelse\n  echo \"no match\"\nfi"
    if "array" in concept:
        return "arr=(one two three)\nfor item in \"${arr[@]}\"; do\n  echo \"$item\"\ndone"
    if "awk" in concept:
        return "awk 'PROGRAM' \"$1\""
    if "sed" in concept:
        return "sed 's/old/new/' \"$1\""
    if "trap" in concept:
        return "trap 'echo \"handled\"' EXIT\n# TODO: do the work"
    if "curl" in concept:
        return "curl --silent --fail \"$1\""
    if "jq" in concept:
        return "jq -r '.field' \"$1\""
    if "flock" in concept:
        return "flock /tmp/example.lock -c 'echo locked'"
    if test["expected_stdout"]:
        lines = test["expected_stdout"].split("\n")
        if len(lines) == 1:
            return f'printf "%s\\n" "{lines[0]}"'
    return '# TODO: implement the exact behavior required by the mission'


def build_hint_three(level: LevelSpec) -> str:
    return f"Start from something close to this:\n\n#!/usr/bin/env bash\n{snippet_for_level(level)}"


def build_debrief(level: LevelSpec, objective: str) -> str:
    return (
        f"# {level.title}\n\n"
        f"This mission focuses on **{level.concept}**. In real bash work, this pattern matters because scripts are usually stitched together from small, precise behaviors. A reliable script is often just a collection of reliable little decisions.\n\n"
        f"Here, the job was: {objective} That kind of exact contract is common in automation, CI jobs, deploy helpers, and ops tooling where another script or service is depending on your output and exit code.\n\n"
        "The bigger lesson is to prefer the shell feature that matches the problem directly. When you use the right tool or language feature, the script is easier to test, safer to change, and much easier for the next person to understand."
    )


def build_scaffold(level: LevelSpec, objective: str) -> str:
    return (
        "#!/usr/bin/env bash\n"
        f"# TODO: {objective}\n"
        "#\n"
        f"# Example: {snippet_for_level(level)}\n"
    )


def parse_fixture_list(text: str) -> list[str]:
    inner = text.strip().strip("[]").strip()
    if not inner:
        return []
    values = []
    for item in inner.split(","):
        cleaned = re.sub(r"\s*\(chmod\s*\d{3}\)\s*", "", item.strip())
        if cleaned:
            values.append(cleaned)
    return values


def unique_tests(tests: list[dict]) -> list[dict]:
    seen = set()
    result = []
    for test in tests:
        key = (
            tuple(test["args"]),
            test["expected_stdout"],
            test["expected_exit"],
            test["comparison"],
        )
        if key in seen:
            continue
        seen.add(key)
        result.append(test)
    return result


def parse_inline_fixtures(line: str) -> list[tuple[str, str]]:
    return [(path.strip(), decode_escaped(content)) for path, content in FIXTURE_INLINE_RE.findall(line)]


def infer_fixture_from_list(name: str) -> str:
    lower = name.lower()
    if lower.endswith(".json"):
        return '{"status":"ok"}\n'
    if lower.endswith(".csv"):
        return "col1,col2\nvalue1,value2\n"
    if lower.endswith(".conf") or lower.endswith(".txt") or lower.endswith(".env"):
        return "sample\n"
    if lower.endswith(".sh"):
        return "#!/usr/bin/env bash\necho sample\n"
    return "sample\n"


def parse_fixture_modes(line: str) -> dict[str, int]:
    modes = {}
    for path, mode in re.findall(r"([A-Za-z0-9_./-]+)\s*\(chmod\s*(\d{3})\)", line):
        modes[path] = int(mode, 8)
    return modes


def collect_levels(spec_path: Path) -> list[LevelSpec]:
    titles = load_titles()
    lines = spec_path.read_text(encoding="utf-8").splitlines()
    spec_name = spec_path.name
    current_module: ModuleMeta | None = None
    current_level: LevelSpec | None = None
    levels: list[LevelSpec] = []
    in_target = False

    for raw_line in lines:
        line = raw_line.rstrip()
        if line.startswith("## WHAT TO WRITE FOR EACH LEVEL"):
            break
        range_match = MODULE_RANGE_RE.search(line)
        if range_match:
            in_target = True
            continue
        module_match = MODULE_RE.match(line)
        if module_match:
            module_number = int(module_match.group(1))
            difficulty, xp_min, xp_max, scaffold = defaults_for_spec(spec_name, module_number)
            current_module = ModuleMeta(
                number=module_number,
                display=module_match.group(2).strip(),
                difficulty=difficulty,
                xp_min=xp_min,
                xp_max=xp_max,
                scaffold=scaffold,
            )
            continue
        if not in_target or current_module is None:
            continue
        base_match = BASE_DIR_RE.match(line)
        if base_match:
            current_module.base_dir = base_match.group(1)
            continue
        if line.startswith("difficulty: "):
            difficulty_part = line.split("difficulty:", 1)[1].strip()
            current_module.difficulty = difficulty_part.split(",", 1)[0].strip()
            current_module.xp_min, current_module.xp_max = parse_range(line)
            scaffold_match = re.search(r"scaffold:\s*(true|false)", line)
            if scaffold_match:
                current_module.scaffold = scaffold_match.group(1) == "true"
            continue
        level_match = LEVEL_RE.match(line)
        if level_match:
            if current_level:
                levels.append(current_level)
            level_id = int(level_match.group(3))
            current_level = LevelSpec(
                id=level_id,
                slug=level_match.group(2),
                title=titles.get(level_id, level_match.group(2).replace("-", " ").title()),
                module=ModuleMeta(
                    number=current_module.number,
                    display=current_module.display,
                    base_dir=current_module.base_dir,
                    difficulty=current_module.difficulty,
                    xp_min=current_module.xp_min,
                    xp_max=current_module.xp_max,
                    scaffold=current_module.scaffold,
                ),
            )
            continue
        if current_level is None:
            continue
        if line.startswith("Concept: "):
            concept_body = line[len("Concept: "):].strip()
            first_sentence = concept_body.split(". ", 1)
            current_level.concept = first_sentence[0].strip()
            if len(first_sentence) > 1:
                current_level.objective_lines.append(first_sentence[1].strip())
            continue
        if line.startswith("Test: "):
            parsed = parse_test_line(line)
            if parsed is not None:
                current_level.tests.append(parsed)
            else:
                current_level.objective_lines.append(line.replace("Test: ", "", 1).strip())
            continue
        if line.startswith("fixtures: "):
            current_level.fixtures = parse_fixture_list(line.split(":", 1)[1].strip())
            continue
        if line.startswith("fixture "):
            for path, content in parse_inline_fixtures(line):
                current_level.fixture_data[path] = content
            current_level.fixture_modes.update(parse_fixture_modes(line))
            continue
        if line.strip():
            current_level.objective_lines.append(line.strip())
            current_level.fixture_modes.update(parse_fixture_modes(line))

    if current_level:
        levels.append(current_level)
    return levels


def ensure_fixture_data(level: LevelSpec) -> None:
    for fixture in level.fixtures:
        level.fixture_data.setdefault(fixture, infer_fixture_from_list(fixture))


def write_level(level: LevelSpec) -> None:
    ensure_fixture_data(level)
    level.tests = unique_tests(level.tests)
    level_dir = MODULES_DIR / level.module.base_dir / f"level-{level.id:03d}-{level.slug}"
    level_dir.mkdir(parents=True, exist_ok=True)

    fixtures_dir = level_dir / "fixtures"
    if fixtures_dir.exists():
        shutil.rmtree(fixtures_dir)
    fixtures_dir.mkdir(parents=True, exist_ok=True)

    for fixture_name, content in level.fixture_data.items():
        fixture_path = fixtures_dir / fixture_name
        fixture_path.parent.mkdir(parents=True, exist_ok=True)
        fixture_path.write_text(content, encoding="utf-8")
        mode = level.fixture_modes.get(fixture_name)
        if mode is not None:
            fixture_path.chmod(mode)
        elif fixture_name.endswith(".sh"):
            fixture_path.chmod(0o755)

    objective = default_objective(level)
    mission = {
        "id": level.id,
        "module": level.module.number,
        "module_name": level.module.base_dir.split("-", 2)[2],
        "module_display": level.module.display,
        "title": level.title,
        "difficulty": level.module.difficulty,
        "xp": choose_xp(level.id, level.module.xp_min, level.module.xp_max),
        "objective": objective,
        "expected_script_name": "solution.sh",
        "test_cases": level.tests,
        "fixtures": sorted(level.fixtures),
        "concepts": parse_concepts(level.concept),
        "scaffold": level.module.scaffold,
    }
    (level_dir / "mission.yaml").write_text(
        yaml.safe_dump(mission, sort_keys=False, allow_unicode=False),
        encoding="utf-8",
    )

    (level_dir / "hint-1.txt").write_text(hint_from_concept(level.concept, level.id) + "\n", encoding="utf-8")
    (level_dir / "hint-2.txt").write_text(
        f"Structure the script around the exact contract for `{level.title}`. {objective}\n",
        encoding="utf-8",
    )
    (level_dir / "hint-3.txt").write_text(build_hint_three(level) + "\n", encoding="utf-8")
    (level_dir / "debrief.md").write_text(build_debrief(level, objective) + "\n", encoding="utf-8")

    solution_path = level_dir / "solution.sh"
    if level.module.scaffold:
        solution_path.write_text(build_scaffold(level, objective), encoding="utf-8")
    elif solution_path.exists():
        solution_path.unlink()


def cleanup_stale_dirs(levels: list[LevelSpec]) -> None:
    expected: dict[str, set[str]] = {}
    for level in levels:
        expected.setdefault(level.module.base_dir, set()).add(f"level-{level.id:03d}-{level.slug}")
    for module_dir, valid_names in expected.items():
        path = MODULES_DIR / module_dir
        if not path.exists():
            continue
        for child in path.iterdir():
            if child.is_dir() and child.name.startswith("level-") and child.name not in valid_names:
                shutil.rmtree(child)


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        raise SystemExit("usage: rewrite_from_spec.py <spec-file>")
    spec_path = Path(argv[1]).resolve()
    levels = collect_levels(spec_path)
    if not levels:
        raise SystemExit(f"No levels parsed from {spec_path}")
    cleanup_stale_dirs(levels)
    for level in levels:
        write_level(level)
    print(f"Rewrote {len(levels)} levels from {spec_path.name}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
