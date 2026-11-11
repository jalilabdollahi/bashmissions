#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh LIST" >&2
  exit 2
fi
list=$1

# A group (not a subshell) so that "exit 1" really ends the script.
[[ -r $list ]] || { echo "cannot read $list" >&2; exit 1; }

# wc -l pads its output on macOS; $(( )) turns it into a plain number.
count=$(( $(awk 'NF' "$list" | sort -u | wc -l) ))

# Three commands, one redirection: the file is opened once and receives
# everything the group prints.
{
  echo "== fleet report =="
  awk 'NF' "$list" | sort -u
  echo "total: $count"
} > report.txt

echo "wrote report.txt ($count servers)"
