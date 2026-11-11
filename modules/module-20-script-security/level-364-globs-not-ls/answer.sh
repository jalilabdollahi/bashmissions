#!/usr/bin/env bash
# Summarise every *.log file in a folder, safely.
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh DIR" >&2
  exit 2
fi

dir=$1
if [[ ! -d $dir ]]; then
  printf 'no such folder: %s\n' "$dir" >&2
  exit 1
fi

# Without nullglob an unmatched pattern stays as the literal text "dir/*.log".
shopt -s nullglob

count=0
for f in "$dir"/*.log; do
  [[ -f $f ]] || continue          # a folder called old.log is not a log
  first=
  # read returns non-zero for an empty file; "|| true" keeps set -e quiet.
  IFS= read -r first < "$f" || true
  printf '%s: %s\n' "${f##*/}" "$first"
  count=$((count + 1))
done
printf 'logs: %d\n' "$count"
