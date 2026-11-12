#!/usr/bin/env bash
# "$1": CSV with header. "$2": the column to summarise, by name.
# Report count, skipped, sum, min, max and average of its numeric cells.

# TODO 1: awk -F, ; on line 1 find which column number $2 is (error if none).
# TODO 2: per data row, test the cell with a regex; numbers update n, sum, min,
#         max (take min and max from the first number, not from 0); others
#         bump "skipped".
# TODO 3: in END print the lines in the required order with printf "%.2f".
# TODO 4: with no numbers, avoid dividing by zero: print only count and skipped.
