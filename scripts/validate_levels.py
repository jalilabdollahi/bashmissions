#!/usr/bin/env python3
"""Quality gate for BashMissions levels.

For every selected level it checks:
  * structure   - all files present, mission.yaml schema, directory naming
  * answer.sh   - passes every test case and the technique checks
  * solution.sh - the starter script must NOT pass (the tests mean something)
  * portability - no GNU-only / BSD-only commands in answers, stubs, checks
  * uniqueness  - no two levels share (or nearly share) texts or answers

Usage:
  python3 scripts/validate_levels.py --all
  python3 scripts/validate_levels.py --module 7 [--module 8]
  python3 scripts/validate_levels.py --level 131 [--level 132]
  add --no-uniqueness to skip the cross-level similarity scan
  add --verbose to print every failing test case in full
"""
from __future__ import annotations

import argparse
import difflib
import re
import subprocess
import sys
from pathlib import Path

import yaml

REPO_ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(REPO_ROOT))

from engine.bashfind import find_bash  # noqa: E402
from engine.runner import check_patterns, run_level  # noqa: E402
from engine.safety import validate_script  # noqa: E402

MODULES_DIR = REPO_ROOT / "modules"
DIFFICULTIES = {"beginner", "intermediate", "advanced", "expert"}
REQUIRED_FILES = [
    "mission.yaml", "hint-1.txt", "hint-2.txt", "hint-3.txt",
    "debrief.md", "common-mistakes.md", "solution-guide.md",
    "answer.sh", "solution.sh",
]
REQUIRED_KEYS = ["id", "module", "module_name", "module_display", "title",
                 "difficulty", "xp", "story", "objective", "concepts", "test_cases"]
ALLOWED_KEYS = set(REQUIRED_KEYS) | {
    "expected_script_name", "required_patterns", "forbidden_patterns",
    "timeout", "fixtures", "scaffold", "single_case",
}
CASE_KEYS = {"name", "args", "stdin", "env", "files", "expected_stdout",
             "expected_stderr", "expected_exit", "comparison",
             "stderr_comparison", "expected_files"}

# (regex, explanation) - commands that behave differently on macOS and Linux.
# A line can opt out with a trailing comment containing "portable-ok".
CMD = r"(?:^\s*|[;&|({]\s*|\$\(\s*|\b(?:if|elif|while|until|then|do|else|time|!)\s+)"  # command position
PORTABILITY_RULES = [
    (r"\bsed\s+(-[a-zA-Z]+\s+)*-i(\s+-|\s+'|\s+\"|\s*$)", "sed -i without a backup suffix (use sed -i.bak)"),
    (r"\bgrep\s+(-[a-zA-Z]*\s+)*-[a-zA-Z]*P", "grep -P (not on macOS)"),
    (r"-printf\b", "find -printf (GNU only)"),
    (r"\bstat\s+-[cf]\b", "stat -c / stat -f (differ between GNU and BSD)"),
    (r"\b(sha\d+sum|md5sum|shasum|md5)\b", "checksum tools differ (use cksum)"),
    (r"\bflock\b", "flock (not on macOS)"),
    (r"\b(g?timeout)\s+\d", "timeout command (not on stock macOS)"),
    (r"\bdate\s+(-[a-zA-Z]*\s+)*-[dj]\b", "date -d / date -j (GNU vs BSD)"),
    (r"\bdate\s+.*--date", "date --date (GNU only)"),
    (r"\breadlink\s+-f\b", "readlink -f (not on older macOS)"),
    (r"\bjq\b", "jq (not installed by default)"),
    (r"\btac\b", "tac (not on macOS)"),
    (r"\bcolumn\b", "column (not on minimal Linux)"),
    (r"\bxargs\s+(-[a-zA-Z]+\s+)*-r\b", "xargs -r (GNU only)"),
    (r"\bsort\s+.*-h\b", "sort -h (not portable)"),
    (r"\bmktemp\s+(-[a-zA-Z]+\s+)*--", "mktemp long options (GNU only)"),
    (r"\bawk\b[^|;]*\b(gensub|strftime|asort|asorti|systime)\b", "gawk-only awk functions"),
    (r"\b(gsed|gawk|ggrep|gdate)\b", "GNU-prefixed tools"),
    (CMD + r"(ip|ss|netstat|ifconfig|systemctl|service|journalctl|iptables)\s", "host-specific system tools (use a stub)"),
    (CMD + r"(curl|wget|nc|dig|nslookup|docker|kubectl|git|ssh|scp|rsync|logger|df|uptime|free|openssl|useradd|userdel|usermod|crontab)(\s|$)", "network/host tool without a stub (provide stubs/<tool>)"),
    (CMD + r"ps\s+-[a-zA-Z]*[eo]", "ps options differ (prefer $! / kill -0 / jobs)"),
]


def strip_comments(text: str) -> str:
    return "\n".join(l for l in text.splitlines() if not l.lstrip().startswith("#"))


def load_levels() -> list[dict]:
    levels = []
    for mission in sorted(MODULES_DIR.glob("module-*/level-*/mission.yaml")):
        data = yaml.safe_load(mission.read_text(encoding="utf-8")) or {}
        level_dir = mission.parent
        data["path"] = str(level_dir.relative_to(REPO_ROOT))
        data["module_path_slug"] = level_dir.parent.name
        data["level_path_slug"] = level_dir.name
        levels.append(data)
    return levels


def structural_problems(level: dict) -> list[str]:
    problems: list[str] = []
    level_dir = REPO_ROOT / level["path"]
    for name in REQUIRED_FILES:
        f = level_dir / name
        if not f.exists():
            problems.append(f"missing {name}")
        elif not f.read_text(encoding="utf-8", errors="replace").strip():
            problems.append(f"empty {name}")
    for key in REQUIRED_KEYS:
        if key not in level or level[key] in (None, "", []):
            problems.append(f"mission.yaml missing '{key}'")
    unknown = set(level) - ALLOWED_KEYS - {"path", "module_path_slug", "level_path_slug"}
    if unknown:
        problems.append(f"mission.yaml has unknown keys {sorted(unknown)}")
    if problems:
        return problems

    lid = int(level["id"])
    if not level["level_path_slug"].startswith(f"level-{lid:03d}-"):
        problems.append(f"directory {level['level_path_slug']} does not match id {lid}")
    if not level["module_path_slug"].startswith(f"module-{int(level['module']):02d}-"):
        problems.append(f"module directory {level['module_path_slug']} does not match module {level['module']}")
    if level["difficulty"] not in DIFFICULTIES:
        problems.append(f"bad difficulty {level['difficulty']}")
    if not isinstance(level["xp"], int) or not 10 <= level["xp"] <= 500:
        problems.append("xp must be an int between 10 and 500")
    if len(str(level["story"]).strip()) < 80:
        problems.append("story is too short (need a real 2-4 sentence scene)")
    if len(str(level["objective"]).strip()) < 40:
        problems.append("objective is too short to be a precise spec")

    cases = level["test_cases"]
    if len(cases) < 2 and not level.get("single_case"):
        problems.append("need at least 2 test cases (or single_case: true when output is truly fixed)")
    names = set()
    for i, case in enumerate(cases, 1):
        extra = set(case) - CASE_KEYS
        if extra:
            problems.append(f"test case {i} has unknown keys {sorted(extra)}")
        if not case.get("name"):
            problems.append(f"test case {i} has no name")
        elif case["name"] in names:
            problems.append(f"duplicate test case name {case['name']!r}")
        names.add(case.get("name"))
        if not any(k in case for k in ("expected_stdout", "expected_stderr", "expected_files")):
            problems.append(f"test case {i} checks nothing")

    hints = [(level_dir / f"hint-{n}.txt").read_text(encoding="utf-8").strip() for n in (1, 2, 3)]
    if len(set(hints)) < 3:
        problems.append("hints are not all different")
    for n, h in enumerate(hints, 1):
        if len(h) < 40:
            problems.append(f"hint-{n} is too short")
    if len((level_dir / "debrief.md").read_text(encoding="utf-8")) < 350:
        problems.append("debrief.md is too thin (< 350 chars)")
    if (level_dir / "common-mistakes.md").read_text(encoding="utf-8").count("\n- ") + \
            (level_dir / "common-mistakes.md").read_text(encoding="utf-8").startswith("- ") < 2:
        problems.append("common-mistakes.md needs at least 2 bullet points")
    if len((level_dir / "solution-guide.md").read_text(encoding="utf-8")) < 500:
        problems.append("solution-guide.md is too thin (< 500 chars)")

    answer = level_dir / "answer.sh"
    ok, msg = validate_script(answer)
    if not ok:
        problems.append(f"answer.sh: {msg}")
    syntax = subprocess.run([find_bash() or "bash", "-n", str(answer)], capture_output=True, text=True)
    if syntax.returncode != 0:
        problems.append(f"answer.sh syntax error: {syntax.stderr.strip()}")
    if (level_dir / "solution.sh").read_bytes() == answer.read_bytes():
        problems.append("solution.sh (starter) is identical to answer.sh")
    return problems


def portability_problems(level: dict) -> list[str]:
    level_dir = REPO_ROOT / level["path"]
    files = [level_dir / "answer.sh", level_dir / "check.sh"]
    stubs = level_dir / "stubs"
    stub_names = {p.name for p in stubs.iterdir()} if stubs.is_dir() else set()
    problems = []
    for f in files:
        if not f.exists():
            continue
        code = strip_comments(f.read_text(encoding="utf-8", errors="replace"))
        for pattern, why in PORTABILITY_RULES:
            for m in re.finditer(pattern, code, re.MULTILINE):
                words = re.findall(r"[\w.-]+", m.group(0))
                if any(w in stub_names for w in words):
                    continue
                line_start = code.rfind("\n", 0, m.start()) + 1
                line_end = code.find("\n", m.end())
                if "portable-ok" in code[line_start:line_end if line_end != -1 else None]:
                    continue  # author marked this line as intentionally fine
                problems.append(f"{f.name}: {why}  [{m.group(0).strip()[:40]}]")
                break
    return problems


def test_problems(level: dict, verbose: bool) -> list[str]:
    level_dir = REPO_ROOT / level["path"]
    problems = []
    results = run_level(level, level_dir, script_override=level_dir / "answer.sh")
    failed = [r for r in results if not r.get("passed")]
    for r in failed:
        line = f"answer.sh fails [{r.get('name')}]: {r.get('message')}"
        if verbose:
            line += (f"\n        expected stdout={r.get('expected_stdout')!r} stderr={r.get('expected_stderr')!r} exit={r.get('expected_exit')}"
                     f"\n        actual   stdout={r.get('actual_stdout')!r} stderr={r.get('actual_stderr')!r} exit={r.get('actual_exit')}")
        problems.append(line)
    starter = level_dir / "solution.sh"
    if starter.exists():
        s_results = run_level(level, level_dir, script_override=starter)
        if all(r.get("passed") for r in s_results):
            problems.append("starter solution.sh already passes every test - tests are too weak")
    if check_patterns(level, (level_dir / "answer.sh").read_text(encoding="utf-8")):
        problems.append("answer.sh violates its own required/forbidden patterns")
    return problems


def _norm(text: str) -> str:
    return re.sub(r"\s+", " ", text.lower()).strip()


def uniqueness_problems(all_levels: list[dict], selected_ids: set[int]) -> list[str]:
    problems = []
    titles: dict[str, int] = {}
    for lv in all_levels:
        key = _norm(str(lv.get("title", "")))
        if key in titles and (lv["id"] in selected_ids or titles[key] in selected_ids):
            problems.append(f"L{lv['id']}: title duplicates L{titles[key]} ({lv.get('title')})")
        titles.setdefault(key, lv["id"])

    fields = {
        "story": lambda lv, d: str(lv.get("story", "")),
        "objective": lambda lv, d: str(lv.get("objective", "")),
        "debrief.md": lambda lv, d: (d / "debrief.md").read_text(encoding="utf-8") if (d / "debrief.md").exists() else "",
        "common-mistakes.md": lambda lv, d: (d / "common-mistakes.md").read_text(encoding="utf-8") if (d / "common-mistakes.md").exists() else "",
        "solution-guide.md": lambda lv, d: (d / "solution-guide.md").read_text(encoding="utf-8") if (d / "solution-guide.md").exists() else "",
        "hint-1.txt": lambda lv, d: (d / "hint-1.txt").read_text(encoding="utf-8") if (d / "hint-1.txt").exists() else "",
        "hint-2.txt": lambda lv, d: (d / "hint-2.txt").read_text(encoding="utf-8") if (d / "hint-2.txt").exists() else "",
        "hint-3.txt": lambda lv, d: (d / "hint-3.txt").read_text(encoding="utf-8") if (d / "hint-3.txt").exists() else "",
        "answer.sh": lambda lv, d: (d / "answer.sh").read_text(encoding="utf-8") if (d / "answer.sh").exists() else "",
        "solution.sh": lambda lv, d: (d / "solution.sh").read_text(encoding="utf-8") if (d / "solution.sh").exists() else "",
    }
    thresholds = {"answer.sh": 0.92, "solution.sh": 0.97}
    # Word-level comparison. A cheap shingle (3-word) Jaccard filter skips the
    # vast majority of pairs before the exact SequenceMatcher ratio runs.
    prepared: dict[str, list[tuple[int, list[str], set]]] = {name: [] for name in fields}
    for lv in all_levels:
        d = REPO_ROOT / lv["path"]
        for name, getter in fields.items():
            words = _norm(getter(lv, d)).split()
            shingles = {tuple(words[i:i + 3]) for i in range(max(len(words) - 2, 1))} if words else set()
            prepared[name].append((lv["id"], words, shingles))

    for name, items in prepared.items():
        limit = thresholds.get(name, 0.85)
        for id_a, words_a, sh_a in items:
            if id_a not in selected_ids or not words_a:
                continue
            for id_b, words_b, sh_b in items:
                if id_b == id_a or not words_b or (id_b in selected_ids and id_b < id_a):
                    continue
                if name == "solution.sh" and len(words_a) < 25 and len(words_b) < 25:
                    continue  # tiny starters are allowed to look alike
                union = len(sh_a | sh_b)
                if union and len(sh_a & sh_b) / union < limit - 0.35:
                    continue
                sm = difflib.SequenceMatcher(None, words_a, words_b, autojunk=False)
                if sm.real_quick_ratio() < limit or sm.quick_ratio() < limit:
                    continue
                ratio = sm.ratio()
                if ratio >= limit:
                    problems.append(f"L{id_a}: {name} is {ratio:.0%} similar to L{id_b}")
    return problems


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--all", action="store_true")
    ap.add_argument("--module", type=int, action="append", default=[])
    ap.add_argument("--level", type=int, action="append", default=[])
    ap.add_argument("--no-uniqueness", action="store_true")
    ap.add_argument("--verbose", action="store_true")
    args = ap.parse_args()

    if not find_bash():
        print("Bash 4+ not found (macOS: brew install bash).")
        return 2

    all_levels = load_levels()
    if args.all:
        selected = all_levels
    else:
        selected = [lv for lv in all_levels
                    if int(lv.get("module", 0)) in args.module or int(lv.get("id", 0)) in args.level]
    if not selected:
        ap.error("nothing selected: use --all, --module N or --level ID")

    ids = [int(lv.get("id", 0)) for lv in all_levels]
    report: dict[int, list[str]] = {}
    if len(ids) != len(set(ids)):
        dupes = sorted({i for i in ids if ids.count(i) > 1})
        report.setdefault(0, []).append(f"duplicate level ids: {dupes}")

    for lv in selected:
        problems = structural_problems(lv)
        if not problems:
            problems += portability_problems(lv)
            problems += test_problems(lv, args.verbose)
        if problems:
            report[int(lv.get("id", 0))] = problems

    if not args.no_uniqueness:
        for line in uniqueness_problems(all_levels, {int(lv["id"]) for lv in selected}):
            lid = int(line.split(":")[0][1:])
            report.setdefault(lid, []).append(line.split(": ", 1)[1])

    for lid in sorted(report):
        print(f"L{lid}:")
        for p in report[lid]:
            print(f"   - {p}")
    bad = len([k for k in report if k])
    print(f"\n{len(selected) - bad}/{len(selected)} levels clean.")
    return 1 if report else 0


if __name__ == "__main__":
    raise SystemExit(main())
