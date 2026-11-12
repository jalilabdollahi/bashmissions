#!/usr/bin/env bash
set -euo pipefail

# -n   do not print every line automatically
# /A/,/B/p   from the first line matching A through the next line matching B, print.
#            After B the range closes and sed waits for the next A, so every block
#            is printed. An unclosed block runs to the end of the file.
sed -n '/BEGIN backup/,/END backup/p' "$1"
