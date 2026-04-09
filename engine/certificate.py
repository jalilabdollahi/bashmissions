"""Module completion certificates."""
from __future__ import annotations

from datetime import datetime
from pathlib import Path


def render_certificate(module_name: str, player_name: str, completed_date: str | None = None) -> str:
    completed_date = completed_date or datetime.now().strftime("%Y-%m-%d")
    return (
        "########################################\n"
        "#        BASHMISSIONS CERTIFICATE      #\n"
        "########################################\n"
        f"Player: {player_name}\n"
        f"Module: {module_name}\n"
        f"Completed: {completed_date}\n"
    )


def save_certificate(module_slug: str, certificate_text: str) -> Path:
    base = Path.home() / ".bashmissions" / "certificates"
    base.mkdir(parents=True, exist_ok=True)
    path = base / f"{module_slug}.txt"
    path.write_text(certificate_text, encoding="utf-8")
    return path
