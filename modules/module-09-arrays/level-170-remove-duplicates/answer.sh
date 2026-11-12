#!/usr/bin/env bash
set -euo pipefail
unique=()

for name in "$@"; do
  seen=0
  # Search the result so far (level 168's idea, inline).
  for kept in "${unique[@]}"; do
    if [[ $kept == "$name" ]]; then
      seen=1
      break
    fi
  done
  if (( seen == 0 )); then
    unique+=("$name")      # first time we meet this name: keep it
  fi
done

if (( ${#unique[@]} > 0 )); then
  printf '%s\n' "${unique[@]}"
fi
echo "removed: $(( $# - ${#unique[@]} ))"
