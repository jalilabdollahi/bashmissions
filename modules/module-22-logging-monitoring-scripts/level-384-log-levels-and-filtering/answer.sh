#!/usr/bin/env bash
# Filter log lines by severity: names become numbers, and numbers compare.
set -euo pipefail

declare -A rank=([ERROR]=1 [WARN]=2 [INFO]=3 [DEBUG]=4)   # smaller = more important

threshold=${LOG_LEVEL:-INFO}
if [[ -z ${rank[$threshold]:-} ]]; then
  echo "unknown LOG_LEVEL: $threshold" >&2
  exit 2
fi

while IFS= read -r line; do
  level=${line%% *}                       # first word of the line
  if [[ -z ${rank[$level]:-} ]]; then
    echo "skipped: $line" >&2
    continue
  fi
  if (( rank[$level] <= rank[$threshold] )); then
    printf '%s\n' "$line"
  fi
done
