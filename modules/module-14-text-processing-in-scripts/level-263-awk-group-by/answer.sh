#!/usr/bin/env bash
set -euo pipefail

# rows[customer] counts lines, gb[customer] adds up the third column.
# NR > 1 skips the header. awk lists array keys in no particular order,
# so sort makes the report reproducible.
awk -F, '
  NR > 1 {
    rows[$2]++
    gb[$2] += $3
  }
  END {
    for (c in rows) print c "," rows[c] "," gb[c]
  }
' "$1" | sort
