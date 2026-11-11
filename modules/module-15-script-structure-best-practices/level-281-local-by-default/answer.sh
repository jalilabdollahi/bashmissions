#!/usr/bin/env bash
# Tank stock rows. Reads "NAME COUNT" lines from stdin.
set -euo pipefail

format_row() {
  # local gives these names a private scope: the caller's name/count are untouched.
  local name=${1^^}
  local count=$2
  local pad=$(( 10 - ${#name} ))
  printf '%s%*s %s\n' "$name" "$pad" "" "$count"
}

main() {
  local rows=0 total=0 name count
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

main
