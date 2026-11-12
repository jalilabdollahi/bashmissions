#!/usr/bin/env bash
set -euo pipefail

awk -F, -v name="$2" '
  { sub(/\r$/, "") }

  NR == 1 {
    for (i = 1; i <= NF; i++) if ($i == name) col = i
    if (!col) {
      print "unknown column: " name > "/dev/stderr"   # portable-ok
      failed = 1
      exit 1
    }
    next
  }

  $0 == "" { next }

  {
    v = $col
    if (v ~ /^-?[0-9]+(\.[0-9]+)?$/) {
      v += 0                          # now a real number
      n++
      sum += v
      # min and max start from the first value: starting from 0 would be
      # wrong for a column that is all negative (or all large).
      if (n == 1 || v < min) min = v
      if (n == 1 || v > max) max = v
    } else {
      skipped++
    }
  }

  END {
    if (failed) exit 1
    printf "count=%d\nskipped=%d\n", n, skipped
    if (n > 0)
      printf "sum=%.2f\nmin=%.2f\nmax=%.2f\navg=%.2f\n", sum, min, max, sum / n
  }
' "$1"
