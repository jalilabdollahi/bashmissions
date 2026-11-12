#!/usr/bin/env bash
set -euo pipefail

# One place knows how a row looks and what the thresholds are.
print_row() {
  local host=$1 pct=$2 label=OK
  if (( pct >= 90 )); then
    label=CRIT
  elif (( pct >= 70 )); then
    label=WARN
  fi
  printf '%-10s %3d%%  %s\n' "$host" "$pct" "$label"
}

rows=0
while read -r host pct; do
  [[ -z $host ]] && continue          # blank line: nothing to print
  print_row "$host" "$pct"            # the function is called once per line
  rows=$(( rows + 1 ))
done
echo "rows: $rows"
