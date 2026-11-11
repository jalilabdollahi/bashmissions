"""Sandbox creation and script execution.

Every test case runs in its own fresh directory under /tmp/bashmissions/_runs,
with a pristine copy of the level fixtures, the player's script, a clean
environment and a fake $HOME. Nothing a previous test (or the player) left
behind can change the result.
"""
from __future__ import annotations

import os
import re
import shutil
import signal
import subprocess
import tempfile
from pathlib import Path

try:
    from engine.bashfind import find_bash
    from engine.scaffold import create_starter_script
    from engine.safety import ensure_workspace, validate_script
    from engine.validator import compare_output
except ModuleNotFoundError:
    from bashfind import find_bash
    from scaffold import create_starter_script
    from safety import ensure_workspace, validate_script
    from validator import compare_output

REPO_ROOT = Path(__file__).resolve().parent.parent
TMP_ROOT = Path("/tmp/bashmissions")
RUNS_ROOT = TMP_ROOT / "_runs"
CURRENT_WORKSPACE_LINK = TMP_ROOT / "current"
STUBS_DIRNAME = ".bm-bin"
BASE_PATH = "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
DEFAULT_TIMEOUT = 5
MAX_TIMEOUT = 15


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


def _copy_level_assets(level_dir: Path, target: Path) -> None:
    """Copy fixtures/ and stubs/ of a level into a workspace or run directory."""
    fixtures_dir = level_dir / "fixtures"
    if fixtures_dir.is_dir():
        shutil.copytree(fixtures_dir, target / "fixtures", dirs_exist_ok=True)
    stubs_dir = level_dir / "stubs"
    if stubs_dir.is_dir():
        dest = target / STUBS_DIRNAME
        shutil.copytree(stubs_dir, dest, dirs_exist_ok=True)
        for stub in dest.iterdir():
            if stub.is_file():
                stub.chmod(0o755)


def prepare_level(level_data: dict) -> Path:
    workspace = level_workspace(level_data)
    if workspace.exists():
        shutil.rmtree(workspace)
    workspace.mkdir(parents=True, exist_ok=True)
    level_dir = REPO_ROOT / level_data["path"]
    _copy_level_assets(level_dir, workspace)
    create_starter_script(level_data, level_dir, workspace / level_data.get("expected_script_name", "solution.sh"))
    set_active_workspace(workspace)
    return workspace


# ─────────────────────────────────────────────────────────────────────────────
# Execution helpers
# ─────────────────────────────────────────────────────────────────────────────

def _limits() -> None:
    """Resource limits for the player's script (runs in the child before exec).

    No process-count limit: RLIMIT_NPROC counts every process the user owns,
    so on a normal desktop it makes fork() fail before the script even starts.
    The wall-clock timeout plus process-group kill covers runaway scripts.
    """
    import resource

    for limit, value in (
        (resource.RLIMIT_CPU, 10),
        (resource.RLIMIT_FSIZE, 50 * 1024 * 1024),
    ):
        try:
            soft, hard = resource.getrlimit(limit)
            if hard != resource.RLIM_INFINITY:
                value = min(value, hard)
            resource.setrlimit(limit, (value, hard))
        except (ValueError, OSError):
            pass


def _clean_env(run_dir: Path, bash_path: str, extra: dict | None) -> dict[str, str]:
    home = run_dir / ".home"
    tmp = run_dir / ".tmp"
    home.mkdir(exist_ok=True)
    tmp.mkdir(exist_ok=True)
    bash_dir = str(Path(bash_path).parent)
    path = f"{run_dir / STUBS_DIRNAME}:{bash_dir}:{BASE_PATH}"
    env = {
        "PATH": path,
        "HOME": str(home),
        "TMPDIR": str(tmp),
        "USER": "player",
        "LOGNAME": "player",
        "SHELL": bash_path,
        "LANG": "C",
        "LC_ALL": "C",
        "TZ": "UTC",
        "TERM": "dumb",
        "BASHMISSIONS": "1",
    }
    for key, value in (extra or {}).items():
        env[str(key)] = str(value).replace("{RUN_DIR}", str(run_dir)).replace("{HOME}", str(home))
    return env


def _run_process(cmd: list[str], cwd: Path, env: dict, stdin_text: str | None, timeout: int) -> tuple[str, str, int, bool]:
    proc = subprocess.Popen(
        cmd,
        cwd=cwd,
        env=env,
        stdin=subprocess.PIPE if stdin_text is not None else subprocess.DEVNULL,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        start_new_session=True,
        preexec_fn=_limits,
    )
    try:
        out, err = proc.communicate(stdin_text.encode() if stdin_text is not None else None, timeout=timeout)
        timed_out = False
    except subprocess.TimeoutExpired:
        try:
            os.killpg(proc.pid, signal.SIGKILL)
        except (ProcessLookupError, PermissionError):
            proc.kill()
        out, err = proc.communicate()
        timed_out = True
    return (
        out.decode("utf-8", errors="replace"),
        err.decode("utf-8", errors="replace"),
        proc.returncode,
        timed_out,
    )


def _strip_comments(script_text: str) -> str:
    lines = []
    for line in script_text.splitlines():
        if line.lstrip().startswith("#"):
            continue
        lines.append(line)
    return "\n".join(lines)


def check_patterns(level_data: dict, script_text: str) -> list[str]:
    """Return messages for required/forbidden pattern violations."""
    code = _strip_comments(script_text)
    problems: list[str] = []
    for rule in level_data.get("required_patterns") or []:
        if not re.search(rule["pattern"], code, re.MULTILINE):
            problems.append(rule.get("message") or f"Your script must use: {rule['pattern']}")
    for rule in level_data.get("forbidden_patterns") or []:
        if re.search(rule["pattern"], code, re.MULTILINE):
            problems.append(rule.get("message") or f"Your script must not use: {rule['pattern']}")
    return problems


def _write_test_files(run_dir: Path, files: dict | None) -> None:
    for rel, content in (files or {}).items():
        target = (run_dir / rel).resolve()
        if run_dir.resolve() not in target.parents:
            raise ValueError(f"Test file escapes the run directory: {rel}")
        if str(rel).endswith("/"):  # "logs/": an empty directory
            target.mkdir(parents=True, exist_ok=True)
            continue
        target.parent.mkdir(parents=True, exist_ok=True)
        if isinstance(content, dict):  # {content: str, mode: "0644", mtime: epoch}
            target.write_text(str(content.get("content", "")), encoding="utf-8")
            if "mode" in content:
                target.chmod(int(str(content["mode"]), 8))
            if "mtime" in content:
                os.utime(target, (int(content["mtime"]), int(content["mtime"])))
        else:
            target.write_text(str(content), encoding="utf-8")


def _check_expected_files(run_dir: Path, expected: dict | None) -> list[str]:
    problems: list[str] = []
    for rel, want in (expected or {}).items():
        target = run_dir / rel
        if want is None:
            if target.exists():
                problems.append(f"{rel} should not exist after your script runs")
            continue
        if want is True:
            if not target.exists():
                problems.append(f"{rel} should exist after your script runs")
            continue
        if not target.is_file():
            problems.append(f"{rel} was not created")
            continue
        got = target.read_text(encoding="utf-8", errors="replace").rstrip("\n")
        if got != str(want).rstrip("\n"):
            problems.append(f"{rel} has the wrong content: expected {str(want)!r}, got {got!r}")
    return problems


def _fail(message: str, args: list[str] | None = None) -> dict:
    return {
        "name": "",
        "args": args or [],
        "expected_exit": 0,
        "actual_exit": 1,
        "passed": False,
        "message": message,
    }


def run_level(level_data: dict, workspace: Path, script_override: Path | None = None) -> list[dict]:
    """Run every test case of a level against the player's script.

    script_override lets tooling (scripts/validate_levels.py) run answer.sh or
    the starter script instead of the player's workspace copy.
    """
    script_name = level_data.get("expected_script_name", "solution.sh")
    solution = script_override or (workspace / script_name)
    if not solution.exists():
        return [_fail(f"{script_name} does not exist yet. Use `edit` to create it.")]
    allowed, message = validate_script(solution)
    if not allowed:
        return [_fail(message)]
    bash_path = find_bash()
    if not bash_path:
        return [_fail("Bash 4 or newer was not found. On macOS run: brew install bash")]

    script_text = solution.read_text(encoding="utf-8", errors="replace")
    pattern_problems = check_patterns(level_data, script_text)

    level_dir = REPO_ROOT / level_data["path"]
    check_script = level_dir / "check.sh"
    timeout = min(int(level_data.get("timeout", DEFAULT_TIMEOUT)), MAX_TIMEOUT)
    RUNS_ROOT.mkdir(parents=True, exist_ok=True)

    results: list[dict] = []
    for index, test_case in enumerate(level_data.get("test_cases", []), start=1):
        args = [str(arg) for arg in (test_case.get("args") or [])]
        run_dir = Path(tempfile.mkdtemp(prefix=f"L{level_data['id']}-", dir=RUNS_ROOT))
        try:
            _copy_level_assets(level_dir, run_dir)
            shutil.copy2(solution, run_dir / script_name)
            (run_dir / script_name).chmod(0o755)
            _write_test_files(run_dir, test_case.get("files"))
            env = _clean_env(run_dir, bash_path, test_case.get("env"))
            stdin_text = test_case.get("stdin")
            if stdin_text is not None:
                stdin_text = str(stdin_text)

            out, err, code, timed_out = _run_process(
                [bash_path, script_name, *args], run_dir, env, stdin_text, timeout
            )
            actual_stdout = out.rstrip("\n")
            actual_stderr = err.rstrip("\n")
            base = {
                "name": test_case.get("name", f"case {index}"),
                "args": args,
                "stdin": stdin_text,
                "expected_stdout": test_case.get("expected_stdout"),
                "actual_stdout": actual_stdout,
                "expected_stderr": test_case.get("expected_stderr"),
                "actual_stderr": actual_stderr,
                "expected_exit": test_case.get("expected_exit", 0),
                "actual_exit": code,
            }
            if timed_out:
                results.append({
                    **base,
                    "actual_exit": 124,
                    "passed": False,
                    "message": f"Your script was stopped after {timeout} seconds. Look for an infinite loop or a command waiting for input.",
                })
                continue

            problems: list[str] = []
            if "expected_stdout" in test_case:
                mode = test_case.get("comparison", "exact")
                if not compare_output(actual_stdout, str(test_case.get("expected_stdout", "")).rstrip("\n"), mode):
                    problems.append("stdout does not match")
            if "expected_stderr" in test_case:
                mode = test_case.get("stderr_comparison", test_case.get("comparison", "exact"))
                if not compare_output(actual_stderr, str(test_case.get("expected_stderr", "")).rstrip("\n"), mode):
                    problems.append("stderr does not match")
            if code != int(test_case.get("expected_exit", 0)):
                problems.append(f"exit code {code}, expected {test_case.get('expected_exit', 0)}")
            problems.extend(_check_expected_files(run_dir, test_case.get("expected_files")))

            if check_script.exists() and not problems:
                with tempfile.NamedTemporaryFile("w", delete=False, dir=run_dir, prefix=".out") as fo:
                    fo.write(out)
                with tempfile.NamedTemporaryFile("w", delete=False, dir=run_dir, prefix=".err") as fe:
                    fe.write(err)
                check_env = {
                    **env,
                    "BM_STDOUT_FILE": fo.name,
                    "BM_STDERR_FILE": fe.name,
                    "BM_EXIT": str(code),
                    "BM_TEST_NAME": base["name"],
                }
                c_out, c_err, c_code, c_timeout = _run_process(
                    [bash_path, str(check_script), *args], run_dir, check_env, None, timeout
                )
                if c_timeout or c_code != 0:
                    problems.append((c_out.strip() or c_err.strip() or "The level checker rejected the result."))

            if problems and actual_stderr and "expected_stderr" not in test_case:
                problems.append(f"stderr: {actual_stderr[-300:]}")
            results.append({**base, "passed": not problems, "message": "; ".join(problems)})
        finally:
            shutil.rmtree(run_dir, ignore_errors=True)

    if pattern_problems:
        results.append(_fail("Technique check: " + " ".join(pattern_problems)))
        results[-1]["name"] = "technique"
    return results
