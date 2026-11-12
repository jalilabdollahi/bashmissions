#!/usr/bin/env bash
# "$1" OLD, "$2" NEW: CSVs with a header, first column is a unique key.
# List added (+), removed (-) and changed (~) rows by key, sorted by key.

# TODO 1: refuse a file with no lines (test -s) and headers that differ.
# TODO 2: one awk run, NEW file first or OLD first, FNR == NR tells which: load
#         old[key] = rest of the row; later rows overwrite earlier ones.
# TODO 3: for the second file compare against old[]; emit "key<TAB>text" lines
#         for + and ~, and for - after the second file ends (walk old[] in END).
# TODO 4: sort those lines by key and cut the key away; print the summary line
#         with counts, or "no differences".
