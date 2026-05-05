"""Sandbox creation and script execution."""
from __future__ import annotations

import os
import shlex
import shutil
import subprocess
from pathlib import Path

try:
    from engine.scaffold import create_starter_script
    from engine.safety import SAFE_PATH, ensure_workspace, validate_script
    from engine.validator import compare_output
except ModuleNotFoundError:
    from scaffold import create_starter_script
    from safety import SAFE_PATH, ensure_workspace, validate_script
    from validator import compare_output

REPO_ROOT = Path(__file__).resolve().parent.parent
TMP_ROOT = Path("/tmp/bashmissions")
CURRENT_WORKSPACE_LINK = TMP_ROOT / "current"


def level_workspace(level_data: dict) -> Path:
    workspace = TMP_ROOT / level_data["module_path_slug"] / level_data["level_path_slug"] / "workspace"
    ensure_workspace(workspace)
    return workspace


def set_active_workspace(workspace: Path) -> None:
    """Point /tmp/bashmissions/current at the workspace for the active level."""
    ensure_workspace(workspace)
    TMP_ROOT.mkdir(parents=True, exist_ok=True)
    if CURRENT_WORKSPACE_LINK.is_symlink() or CURRENT_WORKSPACE_LINK.is_file():
        CURRENT_WORKSPACE_LINK.unlink()
    elif CURRENT_WORKSPACE_LINK.exists():
        return
    CURRENT_WORKSPACE_LINK.symlink_to(workspace, target_is_directory=True)


def copytree_contents(src: Path, dst: Path) -> None:
    if not src.exists():
        return
    for item in src.iterdir():
        target = dst / item.name
        if item.is_dir():
            shutil.copytree(item, target, dirs_exist_ok=True)
        else:
            shutil.copy2(item, target)


def prepare_level(level_data: dict) -> Path:
    workspace = level_workspace(level_data)
    if workspace.exists():
        shutil.rmtree(workspace)
    workspace.mkdir(parents=True, exist_ok=True)
    level_dir = REPO_ROOT / level_data["path"]
    fixtures_dir = level_dir / "fixtures"
    if fixtures_dir.exists():
        shutil.copytree(fixtures_dir, workspace / "fixtures", dirs_exist_ok=True)
    create_starter_script(level_data, level_dir, workspace / "solution.sh")
    set_active_workspace(workspace)
    return workspace


def _bash_command(script_name: str, args: list[str]) -> str:
    quoted = " ".join(shlex.quote(arg) for arg in args)
    return (
        "ulimit -t 5 -f 10240 -u 50 -n 64;"
        f"PATH='{SAFE_PATH}'; bash {shlex.quote(script_name)}"
        + (f" {quoted}" if quoted else "")
    )


def run_level(level_data: dict, workspace: Path) -> list[dict]:
    solution = workspace / level_data.get("expected_script_name", "solution.sh")
    if not solution.exists():
        return [{
            "args": [],
            "expected_exit": 0,
            "actual_exit": 1,
            "passed": False,
            "message": "solution.sh does not exist yet. Use `edit` to create it.",
        }]
    allowed, message = validate_script(solution)
    if not allowed:
        return [{
            "args": [],
            "expected_exit": 0,
            "actual_exit": 1,
            "passed": False,
            "message": message,
        }]
    solution.chmod(0o755)
    level_dir = REPO_ROOT / level_data["path"]
    check_script = level_dir / "check.sh"
    results: list[dict] = []
    for test_case in level_data.get("test_cases", []):
        args = [str(arg) for arg in (test_case.get("args") or [])]
        try:
            run = subprocess.run(
                ["bash", "-lc", _bash_command(solution.name, args)],
                cwd=workspace,
                capture_output=True,
                text=True,
                timeout=5,
                env={**os.environ, "PATH": SAFE_PATH},
            )
            actual_stdout = run.stdout.rstrip("\n")
            actual_stderr = run.stderr.rstrip("\n")
            actual_exit = run.returncode
        except subprocess.TimeoutExpired:
            results.append(
                {
                    "args": args,
                    "expected_stdout": test_case.get("expected_stdout"),
                    "actual_stdout": "",
                    "expected_exit": test_case.get("expected_exit", 0),
                    "actual_exit": 124,
                    "passed": False,
                    "message": "Your script took too long to finish and was stopped after 5 seconds. Check for an infinite loop or a command waiting for input.",
                }
            )
            continue
        passed = True
        message_text = ""
        if check_script.exists():
            try:
                check_run = subprocess.run(
                    ["bash", str(check_script), str(workspace), *args],
                    cwd=workspace,
                    capture_output=True,
                    text=True,
                    timeout=5,
                    env={**os.environ, "PATH": SAFE_PATH},
                )
                passed = check_run.returncode == 0
                message_text = check_run.stdout.strip() or check_run.stderr.strip()
            except subprocess.TimeoutExpired:
                passed = False
                message_text = "The level checker took too long to finish and was stopped after 5 seconds."
        else:
            passed = compare_output(actual_stdout, test_case.get("expected_stdout", ""), test_case.get("comparison", "exact"))
            if "expected_stderr" in test_case:
                stderr_mode = test_case.get("stderr_comparison", test_case.get("comparison", "exact"))
                passed = passed and compare_output(actual_stderr, test_case.get("expected_stderr", ""), stderr_mode)
            passed = passed and actual_exit == test_case.get("expected_exit", 0)
            if not passed and actual_stderr:
                message_text = actual_stderr
        results.append(
            {
                "args": args,
                "expected_stdout": test_case.get("expected_stdout"),
                "actual_stdout": actual_stdout,
                "expected_stderr": test_case.get("expected_stderr"),
                "actual_stderr": actual_stderr,
                "expected_exit": test_case.get("expected_exit", 0),
                "actual_exit": actual_exit,
                "passed": passed,
                "message": message_text,
            }
        )
    return results
