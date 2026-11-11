#!/usr/bin/env bash
set -euo pipefail

file="$1"

# -s is true only if the file exists AND its size is greater than zero,
# so one test covers both "missing" and "empty".
if [[ ! -s $file ]]; then
  echo "empty or missing: $file" >&2
  exit 1
fi

# Wrapping in $(( )) strips the padding spaces that BSD wc adds on macOS.
lines=$(( $(wc -l < "$file") ))
echo "ok: $file, lines: $lines"
