#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

if [[ "${1:-}" == "--reset" ]]; then
  if [ ! -f "progress.json" ]; then
    echo "No progress file found; nothing to reset."
    exit 0
  fi

  read -r -p "Reset all progress? This cannot be undone. [y/N] " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo '{"player_name":null,"total_xp":0,"completed_levels":[],"current_module":1,"current_level":1,"module_certificates":[],"time_per_level":{},"hint_state":{},"skipped_levels":[]}' > progress.json
    echo "Progress reset. Starting from Module 1 Level 1."
  else
    echo "Cancelled."
    exit 0
  fi
  shift
fi

if [[ ! -x .venv/bin/python ]] || ! .venv/bin/python -c "import rich, yaml" >/dev/null 2>&1; then
  echo "Setup is missing or broken. Run ./install.sh first."
  exit 1
fi

exec .venv/bin/python -m engine.engine "$@"
