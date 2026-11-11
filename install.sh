#!/usr/bin/env bash
# One-time setup: Python virtualenv, dependencies, level registry, progress file.
set -euo pipefail
cd "$(dirname "$0")"

find_modern_bash() {
  local candidate
  for candidate in "${BASHMISSIONS_BASH:-}" "$(command -v bash 2>/dev/null)" \
      /opt/homebrew/bin/bash /usr/local/bin/bash /usr/bin/bash /bin/bash; do
    [[ -n "$candidate" && -x "$candidate" ]] || continue
    if [[ "$("$candidate" -c 'echo ${BASH_VERSINFO[0]}')" -ge 4 ]]; then
      echo "$candidate"
      return 0
    fi
  done
  return 1
}

if ! bash_path="$(find_modern_bash)"; then
  echo "BashMissions needs Bash 4 or newer for the missions."
  if [[ "$(uname -s)" == "Darwin" ]]; then
    echo "macOS ships Bash 3.2. Install a modern Bash first:  brew install bash"
  else
    echo "Install bash 4+ with your package manager."
  fi
  exit 1
fi
echo "Using $bash_path for missions."

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required." >&2
  exit 1
fi

python3 -m venv .venv
.venv/bin/python -m pip install --quiet --upgrade pip
.venv/bin/python -m pip install --quiet -r requirements.txt
.venv/bin/python scripts/generate_levels.py

if [ ! -f progress.json ]; then
  echo '{"player_name":null,"total_xp":0,"completed_levels":[],"current_module":1,"current_level":1,"module_certificates":[],"time_per_level":{},"hint_state":{},"skipped_levels":[]}' > progress.json
fi
echo "Installation complete. Run ./play.sh to start."
