#!/usr/bin/env bash
set -euo pipefail

count=0
if [ -p /dev/stdin ]; then
  while IFS= read -r _line; do
    ((count += 1))
  done
fi

echo "piped=$count"
