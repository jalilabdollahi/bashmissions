#!/usr/bin/env bash
# Customer log summary: "NAME: first line" for each *.log file, then a count.
# Theo's loop splits names at spaces and fails on an empty folder.
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh DIR" >&2
  exit 2
fi

dir=$1
[[ -d $dir ]] || { printf 'no such folder: %s\n' "$dir" >&2; exit 1; }

count=0
for f in $(ls $dir/*.log); do
  # TODO: loop over a quoted glob instead, make a no-match glob give an empty
  # list, skip non-files, and print NAME: FIRST_LINE for each file.
  echo "$f"
  count=$((count + 1))
done
echo "logs: $count"
