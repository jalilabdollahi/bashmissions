#!/usr/bin/env bash
# Nightly spool report with a pinned PATH.
set -euo pipefail

# Replace, never extend: the caller's PATH is exactly what we do not trust.
# From this line on, ls/wc/tr/cat can only come from these two system folders.
PATH=/usr/bin:/bin

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh DIR" >&2
  exit 2
fi

dir=$1
entries=$(ls -1 "$dir" | wc -l | tr -d ' ')
printf 'entries: %s\n' "$entries"
cat "$dir/motd.txt"
