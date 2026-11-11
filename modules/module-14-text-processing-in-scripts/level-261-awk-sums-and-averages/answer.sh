#!/usr/bin/env bash
set -euo pipefail

awk '
  { total += $3 }                     # runs for every line; total starts at 0
  END {                               # runs once, after the last line
    avg = (NR > 0) ? total / NR : 0   # NR = number of lines read; avoid dividing by 0
    printf "count=%d total=%.2f avg=%.2f\n", NR, total, avg
  }
' "$1"
