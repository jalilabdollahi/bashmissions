"""Starter script helpers."""
from __future__ import annotations

import shutil
from pathlib import Path


def default_starter() -> str:
    return "#!/usr/bin/env bash\nset -euo pipefail\n\n# TODO: solve the mission\n"


def scaffold_is_answer(scaffold: Path, answer: Path) -> bool:
    return (
        scaffold.exists()
        and answer.exists()
        and scaffold.read_bytes() == answer.read_bytes()
    )


def create_starter_script(level_data: dict, level_dir: Path, target: Path) -> None:
    """Create a learner-facing solution.sh without exposing answer.sh."""
    scaffold = level_dir / "solution.sh"
    answer = level_dir / "answer.sh"
    if scaffold.exists() and not scaffold_is_answer(scaffold, answer):
        shutil.copy2(scaffold, target)
        return
    if level_data.get("scaffold"):
        target.write_text(default_starter(), encoding="utf-8")
