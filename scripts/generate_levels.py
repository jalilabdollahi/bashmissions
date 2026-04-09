#!/usr/bin/env python3
"""Build levels.json from module mission files."""
from __future__ import annotations

import json
from pathlib import Path

import yaml

REPO_ROOT = Path(__file__).resolve().parent.parent
MODULES_DIR = REPO_ROOT / "modules"
OUTPUT_PATH = REPO_ROOT / "levels.json"


def main() -> int:
    levels: list[dict] = []
    for mission_path in sorted(MODULES_DIR.glob("module-*/level-*/mission.yaml")):
        if not mission_path.exists():
            continue
        with mission_path.open("r", encoding="utf-8") as handle:
            level = yaml.safe_load(handle)
        module_dir = mission_path.parent.parent
        level_dir = mission_path.parent
        level["path"] = str(level_dir.relative_to(REPO_ROOT))
        level["module_path_slug"] = module_dir.name
        level["level_path_slug"] = level_dir.name
        levels.append(level)

    levels.sort(key=lambda item: int(item["id"]))
    module_totals = {}
    module_ranges = {}
    for level in levels:
        module_id = int(level["module"])
        module_totals[module_id] = module_totals.get(module_id, 0) + 1
        module_ranges.setdefault(module_id, set()).add(level["difficulty"])
    for level in levels:
        module_id = int(level["module"])
        level["module_total_levels"] = module_totals[module_id]
        level["module_difficulty_range"] = sorted(module_ranges[module_id])

    OUTPUT_PATH.write_text(json.dumps(levels, indent=2), encoding="utf-8")
    print(f"Wrote {len(levels)} levels to {OUTPUT_PATH}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
