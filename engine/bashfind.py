"""Locate a Bash 4+ interpreter (macOS ships Bash 3.2 at /bin/bash)."""
from __future__ import annotations

import os
import shutil
import subprocess
from functools import lru_cache

MIN_MAJOR = 4
CANDIDATES = (
    "/opt/homebrew/bin/bash",
    "/usr/local/bin/bash",
    "/opt/local/bin/bash",
    "/usr/bin/bash",
    "/bin/bash",
)


def bash_major(path: str) -> int:
    try:
        out = subprocess.run(
            [path, "-c", "echo ${BASH_VERSINFO[0]}"],
            capture_output=True, text=True, timeout=5,
        ).stdout.strip()
        return int(out)
    except (OSError, ValueError, subprocess.TimeoutExpired):
        return 0


@lru_cache(maxsize=1)
def find_bash() -> str | None:
    """Return the path of the first Bash >= 4 found, or None."""
    override = os.environ.get("BASHMISSIONS_BASH")
    candidates = [override] if override else []
    which = shutil.which("bash")
    if which:
        candidates.append(which)
    candidates.extend(CANDIDATES)
    seen: set[str] = set()
    for path in candidates:
        if not path or path in seen or not os.access(path, os.X_OK):
            continue
        seen.add(path)
        if bash_major(path) >= MIN_MAJOR:
            return path
    return None
