#!/usr/bin/env bash
# Price-label tool: solution.sh [-u] [-p PREFIX] [--] WORD...
# Ollie's version only understands flags in fixed positions.
set -euo pipefail

upper=0
prefix=""

if [ "${1:-}" = "-u" ]; then
  upper=1
  shift
fi

# TODO: replace the fixed checks with a loop:
#   while [ $# -gt 0 ]; do case "$1" in ... esac; done
# handling -u/--upper, -p/--prefix VALUE, --, unknown options (exit 2),
# and a missing value for -p (exit 2).
if [ "$#" -eq 0 ]; then
  echo "usage: solution.sh [-u] [-p PREFIX] [--] WORD..." >&2
  exit 2
fi

for word in "$@"; do
  if [ "$upper" -eq 1 ]; then word=${word^^}; fi
  printf '%s%s\n' "$prefix" "$word"
done
