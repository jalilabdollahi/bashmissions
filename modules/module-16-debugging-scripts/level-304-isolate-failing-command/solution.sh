#!/usr/bin/env bash
set -euo pipefail

steps=(prepare build deploy)
failing="build"
for step in "${steps[@]}"; do
  if [[ $step == "$failing" ]]; then
    printf 'isolated=%s\n' "$step"
    break
  fi
done
