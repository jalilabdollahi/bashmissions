#!/usr/bin/env python3
"""Rewrite BashMissions modules 1-5 from the 1-5 spec file."""
from __future__ import annotations

import ast
import json
import re
import shutil
from pathlib import Path

import yaml

REPO_ROOT = Path(__file__).resolve().parent.parent
SPEC_PATH = REPO_ROOT / "1-5"
MODULES_DIR = REPO_ROOT / "modules"
LEVELS_JSON = REPO_ROOT / "levels.json"

MODULE_RE = re.compile(r"^## MODULE (\d+) — (.+)$")
BASE_DIR_RE = re.compile(r"^Base dir: ([^/]+)/$")
LEVEL_RE = re.compile(r"^level-(\d+)-([a-z0-9-]+) \(id:(\d+)\)$")

CURRENT_TITLES = {
    int(item["id"]): item["title"]
    for item in json.loads(LEVELS_JSON.read_text(encoding="utf-8"))
}

FIXTURE_CONTENT = {
    44: {"data.txt": "hello there\n"},
    45: {"data.txt": "Charlie\n"},
    46: {"data.txt": "secret123\n"},
    47: {"data.txt": "fast\n"},
    48: {"data.txt": "alpha beta gamma\n"},
    51: {"data.txt": "one\ntwo\nthree\n"},
    52: {"data.txt": "red\nblue\ngreen\n"},
    69: {"data.txt": "present\n"},
    70: {"data.txt": "read me\n"},
    71: {"data.txt": "content lives here\n"},
    87: {"a.txt": "", "b.txt": "", "c.txt": ""},
    88: {"data.txt": "alpha\nbeta\ngamma\n"},
    89: {"data.txt": "one\ntwo\nthree\nfour\nfive\n"},
    92: {"data.txt": "abc\n123\ndef\n"},
    93: {"data.txt": "10\n20\n30\n40\n"},
    99: {"data.txt": "go\nrun\nSTOP\nhidden\n"},
}

XP_VALUES = {
    level_id: 50 + ((level_id - 1) % 6) * 10 for level_id in range(1, 101)
}

OBJECTIVE_OVERRIDES = {
    6: "Write solution.sh that uses printf, not echo, to print exactly two lines: `Name: Alice` and `Age: 30`. Use printf format strings and do not add trailing spaces.",
    9: 'Write solution.sh so it prints `Error: something went wrong` to stderr, prints nothing to stdout, and exits with status 1.',
    12: "Write solution.sh so it prints the value of the HOME environment variable. The test only checks that the output contains `/home`, but your script should print the full HOME path.",
    13: "Write solution.sh so it prints `Today is: ` followed by the current date from `date +%Y-%m-%d`.",
    14: "Write solution.sh so it prints `Script: solution.sh`. Use `$0` and `basename` so the script derives its own filename.",
    16: "Write solution.sh so it prints the word `SUCCESS` in green using ANSI escape codes with printf.",
    44: 'Write solution.sh so it reads the first line from the file path in `$1` and prints `You said: <line>`. Use a read-based file input pattern in the script.',
    45: 'Write solution.sh so it uses `read -p` while reading redirected input from the file path in `$1`, then prints `Name is: <value>`.',
    46: 'Write solution.sh so it uses `read -s` to read the secret from the file path in `$1` and then prints `Password length: N`.',
    47: 'Write solution.sh so it uses `read -t` while reading from the file path in `$1`. If the read succeeds, print the value from the file.',
    52: 'Write solution.sh so it accepts a file path in `$1` and prints `file: N lines`, where `N` is the number of lines in that file. This mission simulates non-interactive input handling.',
    72: 'Write solution.sh so it creates two temporary files, compares their modification times with `-nt` or `-ot`, and prints a result containing the word `newer`.',
    76: 'Write solution.sh so it checks whether the command named in `$1` exists. Print `found: <path>` if it exists, or `not found` if it does not.',
    77: 'Write solution.sh so it inspects `uname -s` and prints exactly one of: `Linux`, `macOS`, or `Other`.',
    87: 'Write solution.sh so it loops over the `.txt` files in the fixture directory and prints each filename by basename only.',
    95: 'Write solution.sh so it simulates a select-style menu by reading the numeric choice from `$1` and printing the matching option text.',
    100: 'Write solution.sh so it starts three background jobs with `&`, waits for them with `wait`, and prints `job N done` lines. The order may vary.',
}


def decode_escaped(text: str) -> str:
    return bytes(text, "utf-8").decode("unicode_escape")


def parse_args(text: str) -> list[str]:
    return ast.literal_eval(text)


def parse_test_line(line: str) -> dict:
    line = line.strip()
    args_match = re.search(r"args:(\[[^\]]*\])", line)
    if not args_match:
        raise ValueError(f"Could not parse args from: {line}")
    args = parse_args(args_match.group(1))

    comparison = "exact"
    expected_exit = 0
    expected_stdout = ""

    if "comparison:contains" in line:
        comparison = "contains"
    elif "comparison:regex" in line:
        comparison = "regex"

    exit_match = re.search(r"exit:(\d+)|expected_exit:(\d+)", line)
    if exit_match:
        expected_exit = int(exit_match.group(1) or exit_match.group(2))

    stdout_match = re.search(r'expected_stdout:"(.*)"', line)
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


def parse_concepts(raw: str) -> list[str]:
    raw = raw.replace("preview of ", "")
    chunks = re.split(r",| \+ | and | / ", raw)
    concepts: list[str] = []
    for chunk in chunks:
        cleaned = chunk.strip().lower()
        if cleaned:
            concepts.append(cleaned.replace(" ", "-"))
    return concepts[:3] or ["bash"]


def parse_fixture_list(text: str) -> list[str]:
    inner = text.strip().strip("[]").strip()
    if not inner:
        return []
    return [item.strip() for item in inner.split(",") if item.strip()]


def syntax_hint(concept: str, level_id: int) -> str:
    concept_lower = concept.lower()
    mapping = [
        ("shebang", '#!/usr/bin/env bash starts the script, and echo "text" prints a line.'),
        ("echo -e", 'Use echo -e "Name:\\tAlice\\nAge:\\t30" when you need escapes like tabs and newlines.'),
        ("printf", 'printf is great for exact output: printf "%s\\n" "text"'),
        ("echo -n", 'echo -n prints without a newline so the next output stays on the same line.'),
        ("stderr", 'Send output to stderr with echo "message" >&2 and choose the right exit code with exit N.'),
        ("$home", 'Expand an environment variable with "$HOME".'),
        ("$(date)", 'Command substitution looks like: today=$(date +%Y-%m-%d)'),
        ("$0", 'Use basename "$0" if you only want the filename of the running script.'),
        ("readonly", 'Mark a variable read-only with readonly NAME=value.'),
        ("unset", 'unset var removes a variable so a default like ${var:-empty} can be used.'),
        ("declare -i", 'declare -i n=10 lets arithmetic like n+=5 work naturally.'),
        ("${", 'Parameter expansion looks like ${var:-default} or ${var:=default}.'),
        ("$1", 'Read the first argument with "$1".'),
        ("$#", 'The number of arguments is stored in "$#".'),
        ('"$@"', 'Loop through arguments safely with: for arg in "$@"; do ...; done'),
        ("shift", 'shift discards the current $1 so the next argument moves into its place.'),
        ("read -p", 'You can combine a prompt and redirected input: read -r -p "Prompt: " value < "$1"'),
        ("read -s", 'read -r -s var reads a secret without echoing it to the terminal.'),
        ("read -a", 'read -r -a arr < "$1" splits a line into array elements.'),
        ("regex", 'Inside [[ ]], regex matching looks like: [[ $value =~ ^[0-9]+$ ]]'),
        ("if [", 'Basic conditionals look like: if [ condition ]; then ... fi'),
        ("[[", 'Double brackets support pattern matching and cleaner compound conditions.'),
        ("case", 'A case block looks like: case "$1" in pattern) ... ;; esac'),
        ("command -v", 'Check if a command exists with command -v bash >/dev/null 2>&1'),
        ("for", 'A for loop can iterate through words, ranges, files, or "$@".'),
        ("while", 'A while loop repeats while a condition stays true.'),
        ("until", 'An until loop repeats until a condition becomes true.'),
        ("select", 'This level simulates a select menu with a case on the numeric choice argument.'),
        ("background", 'Run a job in the background with &, then wait for it before the script exits.'),
    ]
    for key, hint in mapping:
        if key in concept_lower:
            return hint
    return f"This level focuses on {concept}. Start with a small script that uses that exact feature."


def example_snippet(level_id: int, tests: list[dict], concept: str, slug: str) -> str:
    if level_id in {1, 2, 10, 18, 79, 80, 81, 82, 83, 84, 85, 90, 91, 94, 97, 98}:
        expected = tests[0]["expected_stdout"]
        lines = expected.split("\n")
        if len(lines) == 1:
            return f'printf "%s\\n" "{lines[0]}"'
        joined = " ".join(f'"{line}"' for line in lines)
        return f'printf "%s\\n" {joined}'
    if level_id in {3, 7, 12, 13, 14, 19, 20, 21, 22, 23, 24, 25, 26, 27, 30, 31, 32, 33, 34, 35, 36}:
        return "# define the variable(s), then print the requested value"
    if level_id in {37, 38, 39, 41, 42, 43, 49, 50, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 73, 74, 75, 76, 78, 86, 95, 96}:
        return '# use "$1", "$2", or "$@" and print the exact required output'
    if level_id in {44, 45, 46, 47, 48, 51, 52, 69, 70, 71, 87, 88, 89, 92, 93, 99}:
        return 'while IFS= read -r line; do\n# TODO: handle each line\n# done < "$1"'
    if level_id == 72:
        return 'touch "$tmp1"\ntouch "$tmp2"\n[[ "$tmp2" -nt "$tmp1" ]] && echo "newer"'
    if level_id == 77:
        return 'os=$(uname -s)\n# TODO: print Linux, macOS, or Other'
    if level_id == 100:
        return '(echo "job 1 done") &\n(echo "job 2 done") &\n(echo "job 3 done") &\nwait'
    return f"# use {concept} to solve {slug}"


def build_hint_three(level_id: int, tests: list[dict], concept: str, slug: str) -> str:
    snippet = example_snippet(level_id, tests, concept, slug)
    return f"Start from something close to this:\n\n#!/usr/bin/env bash\n{snippet}"


def build_debrief(title: str, concept: str, objective: str) -> str:
    return (
        f"# {title}\n\n"
        f"This mission focuses on **{concept}**. In bash, small syntax differences matter because the shell is both a programming language and a command runner. Getting comfortable with this pattern makes later scripts much easier to read and debug.\n\n"
        f"In this level, the goal was simple on purpose: {objective} That kind of tight, exact output contract is common in automation, where another tool may depend on your script printing the right thing at the right time.\n\n"
        "As you keep going, try to notice when this feature makes a script clearer, safer, or easier to extend. Bash becomes much more manageable when each small building block feels familiar."
    )


def build_scaffold(objective: str, concept: str, level_id: int, tests: list[dict], slug: str) -> str:
    example = example_snippet(level_id, tests, concept, slug)
    return (
        "#!/usr/bin/env bash\n"
        f"# TODO: {objective}\n"
        "#\n"
        f"# Example: {example}\n"
    )


def collect_levels() -> list[dict]:
    lines = SPEC_PATH.read_text(encoding="utf-8").splitlines()
    current_module = None
    base_dir = None
    levels: list[dict] = []
    current_level = None

    for raw_line in lines:
        line = raw_line.rstrip()
        if line.startswith("## WHAT TO WRITE FOR EACH LEVEL"):
            break
        module_match = MODULE_RE.match(line)
        if module_match:
            current_module = {
                "module": int(module_match.group(1)),
                "display": module_match.group(2).strip(),
            }
            continue
        base_match = BASE_DIR_RE.match(line)
        if base_match:
            base_dir = base_match.group(1)
            continue
        level_match = LEVEL_RE.match(line)
        if level_match:
            if current_level:
                levels.append(current_level)
            level_id = int(level_match.group(3))
            current_level = {
                "id": level_id,
                "slug": level_match.group(2),
                "module": current_module["module"],
                "module_display": current_module["display"],
                "base_dir": base_dir,
                "title": CURRENT_TITLES[level_id],
                "body": [],
                "tests": [],
                "fixtures": [],
                "concept": "",
                "objective_seed": "",
            }
            continue
        if not current_level:
            continue
        if line.startswith("Concept: "):
            concept_body = line[len("Concept: "):]
            first_sentence = concept_body.split(". ", 1)
            current_level["concept"] = first_sentence[0].strip()
            current_level["objective_seed"] = first_sentence[1].strip() if len(first_sentence) > 1 else ""
            continue
        if line.startswith("Test: "):
            if "args:" in line:
                current_level["tests"].append(parse_test_line(line))
            else:
                current_level["body"].append(line)
            continue
        if line.startswith("fixtures: "):
            fixtures_text = line.split(":", 1)[1].strip()
            current_level["fixtures"] = parse_fixture_list(fixtures_text)
            continue
        if line.startswith("Note:") or line.startswith("Special:") or line.startswith("BETTER APPROACH:") or line.startswith("Approach:") or line.startswith("comparison:"):
            current_level["body"].append(line)
            continue
        if line.strip():
            current_level["body"].append(line.strip())

    if current_level:
        levels.append(current_level)
    module_levels = [level for level in levels if level["module"] <= 5]
    if not any(level["id"] == 6 for level in module_levels):
        module_levels.insert(
            5,
            {
                "id": 6,
                "slug": "printf-basics",
                "module": 1,
                "module_display": "Hello World & Output",
                "base_dir": "module-01-hello-world-output",
                "title": CURRENT_TITLES[6],
                "body": [
                    'The output must use printf format strings. No trailing spaces.'
                ],
                "tests": [
                    {
                        "args": [],
                        "expected_stdout": "Name: Alice\nAge: 30",
                        "expected_exit": 0,
                        "comparison": "exact",
                    }
                ],
                "fixtures": [],
                "concept": "printf",
                "objective_seed": "Write solution.sh that uses printf (not echo) to print exactly two lines:\n  Name: Alice\n  Age: 30",
            },
        )
    return module_levels


def build_objective(level: dict) -> str:
    if level["id"] in OBJECTIVE_OVERRIDES:
        return OBJECTIVE_OVERRIDES[level["id"]]
    seed = level["objective_seed"]
    extra = []
    for line in level["body"]:
        if line.startswith("Test:") or line.startswith("fixtures:"):
            continue
        if line.startswith("Note:") or line.startswith("Special:") or line.startswith("BETTER APPROACH:") or line.startswith("Approach:"):
            continue
        extra.append(line)
    base = seed.rstrip(".")
    details = " ".join(extra).strip()
    if details and details not in base:
        base = f"{base}. {details}"
    test_note = []
    for test in level["tests"]:
        if test["args"]:
            joined_args = ", ".join(repr(item) for item in test["args"])
            test_note.append(f"When run with [{joined_args}], it must produce the matching expected output.")
            break
    if level["id"] == 9:
        test_note.append("Print the error message to stderr, leave stdout empty, and exit with status 1.")
    if level["id"] in FIXTURE_CONTENT:
        test_note.append("Read the provided fixture file from the path given in the test case.")
    objective = " ".join([piece for piece in [base, *test_note] if piece]).strip()
    return objective


def write_level(level: dict) -> None:
    module_slug = level["base_dir"]
    level_dir = MODULES_DIR / module_slug / f"level-{level['id']:03d}-{level['slug']}"
    level_dir.mkdir(parents=True, exist_ok=True)
    fixtures_dir = level_dir / "fixtures"
    if fixtures_dir.exists():
        shutil.rmtree(fixtures_dir)
    fixtures_dir.mkdir(parents=True, exist_ok=True)

    for name, content in FIXTURE_CONTENT.get(level["id"], {}).items():
        (fixtures_dir / name).write_text(content, encoding="utf-8")

    mission = {
        "id": level["id"],
        "module": level["module"],
        "module_name": module_slug.split("-", 2)[2],
        "module_display": level["module_display"],
        "title": level["title"],
        "difficulty": "beginner",
        "xp": XP_VALUES[level["id"]],
        "objective": build_objective(level),
        "expected_script_name": "solution.sh",
        "test_cases": level["tests"],
        "fixtures": sorted(FIXTURE_CONTENT.get(level["id"], {}).keys()),
        "concepts": parse_concepts(level["concept"]),
        "scaffold": True,
    }
    (level_dir / "mission.yaml").write_text(
        yaml.safe_dump(mission, sort_keys=False, allow_unicode=False),
        encoding="utf-8",
    )

    hint1 = syntax_hint(level["concept"], level["id"])
    hint2 = f"Match the output exactly for {level['title']}. {build_objective(level)}"
    hint3 = build_hint_three(level["id"], level["tests"], level["concept"], level["slug"])
    (level_dir / "hint-1.txt").write_text(hint1 + "\n", encoding="utf-8")
    (level_dir / "hint-2.txt").write_text(hint2 + "\n", encoding="utf-8")
    (level_dir / "hint-3.txt").write_text(hint3 + "\n", encoding="utf-8")

    debrief = build_debrief(level["title"], level["concept"], build_objective(level))
    (level_dir / "debrief.md").write_text(debrief + "\n", encoding="utf-8")

    scaffold = build_scaffold(build_objective(level), level["concept"], level["id"], level["tests"], level["slug"])
    (level_dir / "solution.sh").write_text(scaffold, encoding="utf-8")


def cleanup_stale_dirs(levels: list[dict]) -> None:
    expected: dict[str, set[str]] = {}
    for level in levels:
        expected.setdefault(level["base_dir"], set()).add(f"level-{level['id']:03d}-{level['slug']}")
    for module_dir, valid_names in expected.items():
        path = MODULES_DIR / module_dir
        if not path.exists():
            continue
        for child in path.iterdir():
            if child.is_dir() and child.name.startswith("level-") and child.name not in valid_names:
                shutil.rmtree(child)


def main() -> int:
    levels = collect_levels()
    if len(levels) != 100:
        raise SystemExit(f"Expected 100 levels from 1-5, found {len(levels)}")
    cleanup_stale_dirs(levels)
    for level in levels:
        write_level(level)
    print(f"Rewrote {len(levels)} levels in modules 1-5")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
