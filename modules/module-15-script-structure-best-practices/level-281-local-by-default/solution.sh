#!/usr/bin/env bash
# Tank stock rows. Reads "NAME COUNT" lines from stdin.
# format_row leaks its variables into main's loop, so the "logged" line is wrong.
set -euo pipefail

format_row() {
  name=${1^^}
  count=$2
  pad=$(( 10 - ${#name} ))
  printf '%s%*s %s\n' "$name" "$pad" "" "$count"
}

main() {
  local rows=0 total=0
  while read -r name count; do
    [ -z "$name" ] && continue
    format_row "$name" "$count"
    echo "logged $name"
    rows=$((rows + 1))
    total=$((total + count))
  done
  echo "rows: $rows"
  echo "total: $total"
}

# TODO: make every variable that format_row assigns local (name, count, pad),
# so the loop in main still sees the original lower-case name and count.
main
