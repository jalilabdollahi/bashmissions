#!/usr/bin/env bash
if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh DAY HOST..." >&2
  exit 2
fi
day=$1
shift

# The braces make several commands act as one. Redirections written after the
# closing brace apply to the whole group: the files are opened once, before
# the group starts, so nothing can truncate the middle of the report.
{
  echo "== Capacity report for $day =="
  for host in "$@"; do
    disk-usage "$host"
  done
  echo "== end =="
} > "report-$day.txt" 2> "report-$day.err"

echo "wrote report-$day.txt"
