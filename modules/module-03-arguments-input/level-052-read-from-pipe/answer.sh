#!/usr/bin/env bash
set -euo pipefail

if [ -p /dev/stdin ]; then
  count=0
  while IFS= read -r _line; do
    ((count += 1))
  done
  printf 'pipe: %s lines
' "$count"
else
  echo "no pipe"
fi
