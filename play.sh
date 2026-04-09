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
    echo "{\"player_name\":null,\"total_xp\":0,\"completed_levels\":[],\"current_module\":1,\"current_level\":1,\"module_certificates\":[],\"time_per_level\":{},\"hint_state\":{},\"skipped_levels\":[]}" > progress.json
    echo "Progress reset. Starting from Module 1 Level 1."
  else
    echo "Cancelled."
    exit 0
  fi
fi

source .venv/bin/activate 2>/dev/null || true
python3 -m engine.engine "$@"
