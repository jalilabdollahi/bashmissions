"""Safety helpers for player scripts."""
from __future__ import annotations

from pathlib import Path

SAFE_PATH = "/usr/local/bin:/usr/bin:/bin"
BLOCKED_PATTERNS = [
    "rm -rf /",
    "rm -rf ~",
    ":(){ :|:& };:",
    "sudo",
    "chmod 777 /",
    "/etc/passwd",
    "dd if=/dev/zero",
    "/proc/sysrq-trigger",
]


def validate_script(script_path: Path) -> tuple[bool, str]:
    text = script_path.read_text(encoding="utf-8", errors="replace").lower()
    for pattern in BLOCKED_PATTERNS:
        if pattern.lower() in text:
            return False, f"Blocked pattern detected: {pattern}"
    return True, ""


def ensure_workspace(path: Path) -> None:
    resolved = path.resolve()
    allowed = Path("/tmp/bashmissions").resolve()
    if allowed not in resolved.parents and resolved != allowed:
        raise ValueError(f"Unsafe workspace path: {resolved}")
