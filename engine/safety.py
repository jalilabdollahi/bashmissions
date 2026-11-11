"""Safety helpers for player scripts.

This is a seatbelt against accidents, not a security boundary: player scripts
run as the player's own user, in a throwaway directory with a fake $HOME.
"""
from __future__ import annotations

import re
from pathlib import Path

BLOCKED_PATTERNS = [
    (r"\brm\s+-[a-zA-Z]*r[a-zA-Z]*f?[a-zA-Z]*\s+(/|~|\$HOME)(\s|$|/\*)", "rm -r on / or your home directory"),
    (r":\(\)\s*\{\s*:\|:&\s*\}\s*;\s*:", "fork bomb"),
    (r"(^\s*|[;&|({]\s*|\$\(\s*)sudo\s", "sudo"),
    (r"\bchmod\s+(-R\s+)?777\s+/(\s|$)", "chmod 777 /"),
    (r"\bdd\s+if=/dev/(zero|random|urandom)\s+of=/dev/", "dd onto a device"),
    (r"/proc/sysrq-trigger", "/proc/sysrq-trigger"),
    (r"(^\s*|[;&|({]\s*)mkfs(\.\w+)?\s", "mkfs"),
    (r"(^\s*|[;&|({]\s*)(shutdown|reboot|halt|poweroff)(\s|$)", "shutdown/reboot"),
]


def validate_script(script_path: Path) -> tuple[bool, str]:
    text = script_path.read_text(encoding="utf-8", errors="replace")
    for pattern, label in BLOCKED_PATTERNS:
        if re.search(pattern, text, re.MULTILINE):
            return False, f"Blocked for safety: your script contains {label}."
    return True, ""


def ensure_workspace(path: Path) -> None:
    resolved = path.resolve()
    allowed = Path("/tmp/bashmissions").resolve()
    if allowed not in resolved.parents and resolved != allowed:
        raise ValueError(f"Unsafe workspace path: {resolved}")
