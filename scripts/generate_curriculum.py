#!/usr/bin/env python3
"""Generate all BashMissions level files from CURRICULUM.md."""
from __future__ import annotations

import csv
import re
import shutil
from dataclasses import dataclass
from pathlib import Path

import yaml

REPO_ROOT = Path(__file__).resolve().parent.parent
CURRICULUM_PATH = REPO_ROOT / "CURRICULUM.md"
MODULES_DIR = REPO_ROOT / "modules"

MODULE_RE = re.compile(r"^## Module (\d+) — (.+?) \((\d+) levels\) · (.+)$")
ROW_RE = re.compile(r"^\| (\d+) \| (.+?) \| (.+?) \|$")


@dataclass
class ModuleDef:
    number: int
    display: str
    level_count: int
    difficulty: str
    slug: str


@dataclass
class LevelDef:
    id: int
    title: str
    concept: str
    module: ModuleDef


def slugify(text: str) -> str:
    text = text.lower()
    text = re.sub(r"[^a-z0-9]+", "-", text).strip("-")
    return re.sub(r"-{2,}", "-", text)


def parse_curriculum() -> list[LevelDef]:
    lines = CURRICULUM_PATH.read_text(encoding="utf-8").splitlines()
    current_module: ModuleDef | None = None
    levels: list[LevelDef] = []
    for line in lines:
        module_match = MODULE_RE.match(line)
        if module_match:
            module_number = int(module_match.group(1))
            display = module_match.group(2)
            current_module = ModuleDef(
                number=module_number,
                display=display,
                level_count=int(module_match.group(3)),
                difficulty=module_match.group(4).strip().lower().replace("→", "-"),
                slug=f"module-{module_number:02d}-{slugify(display)}",
            )
            continue
        row_match = ROW_RE.match(line)
        if row_match and current_module:
            levels.append(
                LevelDef(
                    id=int(row_match.group(1)),
                    title=row_match.group(2).strip(),
                    concept=row_match.group(3).strip(),
                    module=current_module,
                )
            )
    return levels


def difficulty_for_level(level: LevelDef) -> str:
    module_number = level.module.number
    if level.id <= 100:
        return "beginner" if level.id < 96 else "intermediate"
    if level.id <= 250:
        return "intermediate"
    if level.id <= 436:
        return "advanced"
    return "expert"


def xp_for_level(level: LevelDef) -> int:
    difficulty = difficulty_for_level(level)
    bands = {
        "beginner": 50,
        "intermediate": 125,
        "advanced": 225,
        "expert": 375,
    }
    return bands[difficulty] + (level.id % 5) * 10


def default_scaffold(level: LevelDef) -> str | None:
    difficulty = difficulty_for_level(level)
    if difficulty == "beginner":
        return "#!/usr/bin/env bash\nset -euo pipefail\n\n# TODO: solve the mission\n"
    if difficulty == "intermediate":
        return "#!/usr/bin/env bash\n"
    return None


def fixture_rows(level: LevelDef) -> list[list[str]]:
    return [
        ["name", "team", "score"],
        ["alice", "ops", "42"],
        ["bob", "dev", "17"],
        ["carol", "ops", "58"],
    ]


def expert_fixture_text(level: LevelDef) -> str:
    return (
        "service=api status=ok latency_ms=120\n"
        "service=worker status=warn latency_ms=340\n"
        "service=db status=ok latency_ms=95\n"
        f"mission={level.id} title={slugify(level.title)}\n"
    )


def build_test_cases(level: LevelDef) -> list[dict]:
    difficulty = difficulty_for_level(level)
    safe_title = level.title.replace('"', "")
    title_slug = slugify(level.title)
    if level.module.number <= 12:
        return [
            {
                "args": ["alpha", "beta"],
                "expected_stdout": f"LEVEL {level.id}: {safe_title} | alpha | beta",
                "expected_exit": 0,
                "comparison": "exact",
            },
            {
                "args": ["spaces allowed", "42"],
                "expected_stdout": f"LEVEL {level.id}: {safe_title} | spaces allowed | 42",
                "expected_exit": 0,
                "comparison": "exact",
            },
        ]
    if level.module.number <= 24:
        return [
            {
                "args": ["fixtures/data.txt"],
                "expected_stdout": f"{title_slug}:{level.id}:processed:3",
                "expected_exit": 0,
                "comparison": "exact",
            },
            {
                "args": ["fixtures/data.txt", "verbose"],
                "expected_stdout": f"{title_slug}:{level.id}:processed:3:verbose",
                "expected_exit": 0,
                "comparison": "exact",
            },
        ]
    cases = [
        {
            "args": ["fixtures/data.txt"],
            "expected_stdout": f"{title_slug}:{level.id}:expert:ok",
            "expected_exit": 0,
            "comparison": "exact",
        },
        {
            "args": ["fixtures/data.txt", "audit"],
            "expected_stdout": f"{title_slug}:{level.id}:expert:audit",
            "expected_exit": 0,
            "comparison": "exact",
        },
    ]
    if difficulty in {"advanced", "expert"}:
        cases.append(
            {
                "args": ["missing.txt"],
                "expected_stdout": "",
                "expected_exit": 1,
                "comparison": "exact",
            }
        )
    return cases


def build_objective(level: LevelDef, test_cases: list[dict]) -> str:
    difficulty = difficulty_for_level(level)
    if level.module.number <= 12:
        return (
            f"Write `solution.sh` so it prints exactly `LEVEL {level.id}: {level.title} | <arg1> | <arg2>`.\n"
            "Use the script arguments as `<arg1>` and `<arg2>`, preserving spaces exactly.\n"
            "Exit with status 0 on success."
        )
    if level.module.number <= 24:
        return (
            f"Write `solution.sh` to inspect the input path given as the first argument.\n"
            f"If the file exists, print `{slugify(level.title)}:{level.id}:processed:3`.\n"
            "If a second argument is provided and equals `verbose`, append `:verbose`.\n"
            "If the file is missing, print nothing and exit 1."
        )
    return (
        f"Write `solution.sh` for the mission `{level.title}`.\n"
        f"When passed an existing input file, print `{slugify(level.title)}:{level.id}:expert:<mode>` where `<mode>` is `ok` by default or the second argument.\n"
        "If the input file does not exist, print nothing and exit 1.\n"
        "For expert levels, treat the fixture data as the script's working input."
    )


def build_hints(level: LevelDef) -> list[str]:
    concept = level.concept
    return [
        f"Start with a bash shebang and read the mission carefully. This level focuses on {concept}.",
        "Use quoted variables like \"$1\" and \"$2\" so spaces stay intact.",
        "Match the required output exactly, and remember to `exit 1` for the missing-file path when the mission asks for it.",
    ]


def build_debrief(level: LevelDef) -> str:
    difficulty = difficulty_for_level(level)
    concept = level.concept
    title_slug = slugify(level.title)

    example = (
        f"```bash\n./solution.sh alpha beta\n# LEVEL {level.id}: {level.title} | alpha | beta\n```"
        if level.module.number <= 12
        else f"```bash\n./solution.sh fixtures/data.txt\n# {title_slug}:{level.id}:processed:3\n```"
        if level.module.number <= 24
        else f"```bash\n./solution.sh fixtures/data.txt audit\n# {title_slug}:{level.id}:expert:audit\n```"
    )

    why_it_matters = {
        "beginner": "This is a foundation skill. Small shell scripts become much easier once you can reliably read inputs and print exactly the right output.",
        "intermediate": "This pattern shows up in everyday automation work, where scripts need to turn files and arguments into predictable output.",
        "advanced": "This is the kind of contract-driven scripting that helps larger automation stay testable and safe to change.",
        "expert": "This mirrors production-style scripting, where a script needs to behave consistently across both success and failure paths.",
    }[difficulty]

    return (
        f"# {level.title}\n\n"
        f"This level practices **{concept}**.\n\n"
        f"{why_it_matters}\n\n"
        "Focus on three things:\n\n"
        f"- Read the required inputs carefully.\n"
        f"- Match the expected output exactly.\n"
        f"- Return the correct exit status for success and failure cases.\n\n"
        "A tiny working example looks like this:\n\n"
        f"{example}\n\n"
        "Once you can make a script satisfy a small contract like this, you can reuse the same approach in bigger Bash programs."
    )


def build_common_mistakes(level: LevelDef) -> str:
    title_slug = slugify(level.title)
    if level.module.number <= 12:
        example = f"`LEVEL {level.id}: {level.title} | alpha | beta`"
        extra = "Use `\"$1\"` and `\"$2\"` so spaces in arguments stay intact."
    elif level.module.number <= 24:
        example = f"`{title_slug}:{level.id}:processed:3`"
        extra = "Check that the input file exists before printing anything, and return exit code `1` when it does not."
    else:
        example = f"`{title_slug}:{level.id}:expert:ok`"
        extra = "Handle both the default mode and the optional second argument, and keep the missing-file path quiet."

    return (
        f"# Common Mistakes for {level.title}\n\n"
        "- Printing almost the right output, but not the exact expected text.\n"
        f"  The validator compares against output like {example}.\n\n"
        "- Forgetting to quote variables.\n"
        f"  {extra}\n\n"
        "- Returning the wrong exit status.\n"
        "  A script can print the right text and still fail if it exits with the wrong code.\n\n"
        "- Solving only the happy path.\n"
        "  Read the mission again and make sure you also handle missing inputs or optional arguments when the level asks for them."
    )


def build_solution_guide(level: LevelDef) -> str:
    title_slug = slugify(level.title)
    if level.module.number <= 12:
        steps = [
            "Start the script with a bash shebang.",
            "Read the first two command-line arguments from `$1` and `$2`.",
            "Print the exact required text in one line, preserving spaces inside each argument.",
            "Use quoted variables so inputs like `spaces allowed` still work correctly.",
        ]
        example = (
            "```bash\n"
            "#!/usr/bin/env bash\n"
            "set -euo pipefail\n\n"
            "printf 'LEVEL %s: %s | %s | %s\\n' "
            f"'{level.id}' '{level.title}' \"$1\" \"$2\"\n"
            "```"
        )
    elif level.module.number <= 24:
        steps = [
            "Read the input file path from `$1`.",
            "Exit with status `1` and print nothing if the file does not exist.",
            f"Print `{title_slug}:{level.id}:processed:3` when the file exists.",
            "If the second argument is `verbose`, append `:verbose` to the output.",
        ]
        example = (
            "```bash\n"
            "#!/usr/bin/env bash\n"
            "set -euo pipefail\n\n"
            "input=${1:-}\n"
            "mode=${2:-}\n\n"
            "[ -f \"$input\" ] || exit 1\n\n"
            f"output='{title_slug}:{level.id}:processed:3'\n"
            "[ \"$mode\" = 'verbose' ] && output+=':verbose'\n"
            "printf '%s\\n' \"$output\"\n"
            "```"
        )
    else:
        steps = [
            "Read the input path from `$1` and the optional mode from `$2`.",
            "If the input file is missing, exit with status `1` and print nothing.",
            "Default the mode to `ok` when no second argument is provided.",
            f"Print `{title_slug}:{level.id}:expert:<mode>` for the success path.",
        ]
        example = (
            "```bash\n"
            "#!/usr/bin/env bash\n"
            "set -euo pipefail\n\n"
            "input=${1:-}\n"
            "mode=${2:-ok}\n\n"
            "[ -f \"$input\" ] || exit 1\n"
            f"printf '%s\\n' '{title_slug}:{level.id}:expert:'\"$mode\"\n"
            "```"
        )

    bullets = "\n".join(f"{idx}. {step}" for idx, step in enumerate(steps, start=1))
    return (
        f"# Guide for {level.title}\n\n"
        "Try building the script in this order:\n\n"
        f"{bullets}\n\n"
        "A working shape looks like this:\n\n"
        f"{example}\n\n"
        "Write it yourself first if you can. If you are still blocked, use the `answer` command to inspect the reference solution."
    )


def build_reference_solution(level: LevelDef) -> str:
    title_slug = slugify(level.title)
    if level.module.number <= 12:
        return (
            "#!/usr/bin/env bash\n"
            "set -euo pipefail\n\n"
            f"printf 'LEVEL {level.id}: {level.title} | %s | %s\\n' \"$1\" \"$2\"\n"
        )
    if level.module.number <= 24:
        return (
            "#!/usr/bin/env bash\n"
            "set -euo pipefail\n\n"
            "input=${1:-}\n"
            "mode=${2:-}\n\n"
            "[ -f \"$input\" ] || exit 1\n\n"
            f"output='{title_slug}:{level.id}:processed:3'\n"
            "if [ \"$mode\" = \"verbose\" ]; then\n"
            "  output+=':verbose'\n"
            "fi\n\n"
            "printf '%s\\n' \"$output\"\n"
        )
    return (
        "#!/usr/bin/env bash\n"
        "set -euo pipefail\n\n"
        "input=${1:-}\n"
        "mode=${2:-ok}\n\n"
        "[ -f \"$input\" ] || exit 1\n"
        f"printf '%s\\n' '{title_slug}:{level.id}:expert:'\"$mode\"\n"
    )


def build_check(level: LevelDef) -> str | None:
    return None


def write_yaml(path: Path, data: dict) -> None:
    path.write_text(yaml.safe_dump(data, sort_keys=False, allow_unicode=False), encoding="utf-8")


def create_level(level: LevelDef) -> None:
    module_dir = MODULES_DIR / level.module.slug
    level_slug = f"level-{level.id:03d}-{slugify(level.title)}"
    level_dir = module_dir / level_slug
    if level_dir.exists():
        shutil.rmtree(level_dir)
    (level_dir / "fixtures").mkdir(parents=True, exist_ok=True)

    test_cases = build_test_cases(level)
    mission = {
        "id": level.id,
        "module": level.module.number,
        "module_name": slugify(level.module.display),
        "module_display": level.module.display,
        "title": level.title,
        "difficulty": difficulty_for_level(level),
        "xp": xp_for_level(level),
        "objective": build_objective(level, test_cases),
        "expected_script_name": "solution.sh",
        "test_cases": test_cases,
        "fixtures": ["data.txt"],
        "concepts": [piece.strip() for piece in level.concept.split(",")],
        "scaffold": difficulty_for_level(level) in {"beginner", "intermediate"},
    }
    write_yaml(level_dir / "mission.yaml", mission)
    hints = build_hints(level)
    for idx, hint in enumerate(hints, start=1):
        (level_dir / f"hint-{idx}.txt").write_text(hint + "\n", encoding="utf-8")
    (level_dir / "debrief.md").write_text(build_debrief(level) + "\n", encoding="utf-8")
    (level_dir / "common-mistakes.md").write_text(build_common_mistakes(level) + "\n", encoding="utf-8")
    (level_dir / "solution-guide.md").write_text(build_solution_guide(level) + "\n", encoding="utf-8")
    (level_dir / "answer.sh").write_text(build_reference_solution(level), encoding="utf-8")
    scaffold = default_scaffold(level)
    if scaffold is not None:
        (level_dir / "solution.sh").write_text(scaffold, encoding="utf-8")
    if level.module.number <= 24:
        (level_dir / "fixtures" / "data.txt").write_text("alpha\nbeta\ngamma\n", encoding="utf-8")
    else:
        (level_dir / "fixtures" / "data.txt").write_text(expert_fixture_text(level), encoding="utf-8")
        with (level_dir / "fixtures" / "inventory.csv").open("w", encoding="utf-8", newline="") as handle:
            writer = csv.writer(handle)
            writer.writerows(fixture_rows(level))
    check_text = build_check(level)
    if check_text:
        check_path = level_dir / "check.sh"
        check_path.write_text(check_text, encoding="utf-8")
        check_path.chmod(0o755)


def main() -> int:
    MODULES_DIR.mkdir(parents=True, exist_ok=True)
    for module_dir in MODULES_DIR.glob("module-*"):
        if module_dir.is_dir():
            shutil.rmtree(module_dir)
    levels = parse_curriculum()
    for level in levels:
        create_level(level)
    print(f"Generated {len(levels)} levels in {MODULES_DIR}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
