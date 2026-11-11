#!/usr/bin/env bash
# Rack-room grid, one text line per row. Store every cell in ONE associative
# array under the key "<row>,<col>", then print the grid flipped: one output
# line per original COLUMN, cells separated by single spaces.
declare -A grid=()
rows=0
cols=0

while read -r -a cells || (( ${#cells[@]} > 0 )); do
  (( ${#cells[@]} == 0 )) && continue
  # TODO: store each cell of this row under grid[<row>,<col>]
  #       and remember how many rows and columns there are
  rows=$(( rows + 1 ))
done

# TODO: for every column, collect its cells from the top row down
#       and print them separated by single spaces
echo "rows=$rows cols=$cols"
