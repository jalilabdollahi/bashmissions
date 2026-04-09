"""Progress persistence for BashMissions."""
from __future__ import annotations

import json
from pathlib import Path

DEFAULT_PROGRESS = {
    "player_name": None,
    "total_xp": 0,
    "completed_levels": [],
    "current_module": 1,
    "current_level": 1,
    "module_certificates": [],
    "time_per_level": {},
    "hint_state": {},
    "skipped_levels": [],
}


class PlayerProgress:
    def __init__(self, path: Path) -> None:
        self.path = path
        self.data = self.load()

    def load(self) -> dict:
        if not self.path.exists():
            self.save(DEFAULT_PROGRESS.copy())
        with self.path.open("r", encoding="utf-8") as handle:
            data = json.load(handle)
        merged = DEFAULT_PROGRESS.copy()
        merged.update(data)
        return merged

    def save(self, data: dict | None = None) -> None:
        if data is not None:
            self.data = data
        self.path.write_text(json.dumps(self.data, indent=2), encoding="utf-8")

    def set_player_name(self, name: str) -> None:
        self.data["player_name"] = name
        self.save()

    def add_xp(self, amount: int) -> None:
        self.data["total_xp"] += amount

    def complete_level(self, level_id: int, elapsed_seconds: float) -> None:
        completed = set(self.data.get("completed_levels", []))
        completed.add(level_id)
        self.data["completed_levels"] = sorted(completed)
        self.data["time_per_level"][str(level_id)] = round(elapsed_seconds, 2)

    def skip_level(self, level_id: int) -> None:
        skipped = set(self.data.get("skipped_levels", []))
        skipped.add(level_id)
        self.data["skipped_levels"] = sorted(skipped)

    def set_current(self, module_id: int, level_id: int) -> None:
        self.data["current_module"] = module_id
        self.data["current_level"] = level_id

    def next_hint_number(self, level_id: int) -> int:
        current = self.data["hint_state"].get(str(level_id), 0) + 1
        self.data["hint_state"][str(level_id)] = current
        self.save()
        return current

    def award_module_certificate(self, module_id: int) -> bool:
        certificates = set(self.data.get("module_certificates", []))
        if module_id in certificates:
            return False
        certificates.add(module_id)
        self.data["module_certificates"] = sorted(certificates)
        return True

