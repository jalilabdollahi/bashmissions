#!/usr/bin/env bash
if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh NAME..." >&2
  exit 2
fi

mkdir -p reports
# "$@" expands to one word per argument and keeps embedded spaces intact.
for name in "$@"; do
  echo "report for $name" > "reports/$name.txt"
  echo "created reports/$name.txt"
done
