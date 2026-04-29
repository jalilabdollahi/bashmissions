#!/usr/bin/env bash
set -euo pipefail

tick=1
while true; do
  if [ "$tick" -gt 2 ]; then
    echo "done"
    break
  fi
  echo "tick=$tick"
  ((tick += 1))
done
