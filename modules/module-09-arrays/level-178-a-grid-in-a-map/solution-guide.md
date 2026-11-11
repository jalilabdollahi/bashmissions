# Walkthrough: A Grid in a Map

## The plan
Bash has one-dimensional arrays only. A grid becomes one associative array where the key says "row,column". Fill it row by row from stdin, then read it back column by column.

## Step by step
1. Declare `declare -A grid=()` and counters `rows` and `cols`.
2. Read each input line into an array of cells with `read -r -a cells`. The loop condition `|| (( ${#cells[@]} > 0 ))` handles a final line that has no newline: `read` fails on it but still fills `cells`.
3. Skip empty lines: if the line produced zero cells, `continue`.
4. For every cell, store it with a composite key: `grid[$rows,$c]=${cells[c]}`. Inside the subscript Bash expands the variables, giving keys like `0,0`, `0,1`, `1,0`. They are plain strings, which is why this works. Then set `cols` to the length of the row and bump `rows`.
5. Transpose with two nested loops, and the order of the loops is the whole trick: the outer loop counts columns `c`, the inner counts rows `r`, so each output line is one original column.
6. Build the line with `line+="${line:+ }${grid[$r,$c]}"`. The expansion `${line:+ }` yields a space only when `line` is already non-empty, so there is no leading space and no trailing space.
7. Print the line after the inner loop.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
declare -A grid=()
rows=0
cols=0
while read -r -a cells || (( ${#cells[@]} > 0 )); do
  (( ${#cells[@]} == 0 )) && continue
  for c in "${!cells[@]}"; do
    grid[$rows,$c]=${cells[c]}
  done
  cols=${#cells[@]}
  rows=$(( rows + 1 ))
done
for (( c = 0; c < cols; c++ )); do
  line=""
  for (( r = 0; r < rows; r++ )); do
    line+="${line:+ }${grid[$r,$c]}"
  done
  echo "$line"
done
```

## Trying it by hand
`printf 'a b c\nd e f\n' | bash solution.sh` prints three lines of two cells. Add `declare -p grid` before the loops to see the keys `0,0`, `0,1`, ...

## An alternative
Store each row as one string in an ordinary array and split it again when you need a cell. It saves the composite key but costs a split on every access, and it falls apart when cells contain separators. The composite-key map keeps each cell separate and directly addressable.
