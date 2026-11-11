#!/usr/bin/env bash
set -euo pipefail
# Report what really changed between two key=value config files:
# "+ added", "- removed", "~ changed", sorted by name, then a summary.

# TODO 1: check the arguments and that both files are readable (exit 2).
# TODO 2: write one function that loads a file into a named associative array
#         (trimmed names and values, comments and blanks skipped).
# TODO 3: build the sorted union of the names of both arrays.
# TODO 4: for every name decide: only new, only old, or in both but different.
#         Show an empty value as ''. Count each kind.
# TODO 5: no differences -> say so, exit 0; otherwise print the summary, exit 1.
