#!/usr/bin/env bash
set -euo pipefail
declare -A grid=()
rows=0
cols=0

# read -a splits the line into an array of cells. A last line without a
# newline makes read fail but still fills cells, hence the "||" part.
while read -r -a cells || (( ${#cells[@]} > 0 )); do
  (( ${#cells[@]} == 0 )) && continue          # skip empty lines
  for c in "${!cells[@]}"; do
    grid[$rows,$c]=${cells[c]}                 # the key is the text "row,col"
  done
  cols=${#cells[@]}
  rows=$(( rows + 1 ))
done

# Transpose: the outer loop walks columns, the inner one walks rows.
for (( c = 0; c < cols; c++ )); do
  line=""
  for (( r = 0; r < rows; r++ )); do
    line+="${line:+ }${grid[$r,$c]}"           # separator only after the first cell
  done
  echo "$line"
done
