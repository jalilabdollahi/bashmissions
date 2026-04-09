#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python3 scripts/generate_curriculum.py
python3 scripts/generate_levels.py
if [ ! -f progress.json ]; then
  echo '{"player_name":null,"total_xp":0,"completed_levels":[],"current_module":1,"current_level":1,"module_certificates":[],"time_per_level":{},"hint_state":{},"skipped_levels":[]}' > progress.json
fi
echo "Installation complete. Run ./play.sh to start."
