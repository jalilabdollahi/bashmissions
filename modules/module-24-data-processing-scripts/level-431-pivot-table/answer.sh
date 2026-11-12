#!/usr/bin/env bash
set -euo pipefail

awk -F, '
  # Insertion sort of a[1..n]. The "" "" forces a text comparison: two names
  # that look like numbers ("9" and "10") would otherwise compare as numbers.
  function isort(a, n,    i, j, t) {
    for (i = 2; i <= n; i++) {
      t = a[i]
      for (j = i - 1; j >= 1 && a[j] "" > t ""; j--) a[j + 1] = a[j]
      a[j + 1] = t
    }
  }

  { sub(/\r$/, "") }
  $0 == "" { next }
  NR == 1  { next }

  $3 !~ /^[0-9]+$/ {
    printf "skipped line %d\n", NR > "/dev/stderr"
    next
  }

  {
    if (!($1 in rseen)) { rseen[$1] = 1; rows[++nr] = $1 }
    if (!($2 in cseen)) { cseen[$2] = 1; cols[++nc] = $2 }
    cell[$1, $2] += $3             # the key is "region" SUBSEP "plan"
    rtot[$1]     += $3
    ctot[$2]     += $3
    grand        += $3
  }

  END {
    isort(rows, nr)
    isort(cols, nc)

    line = "region"
    for (j = 1; j <= nc; j++) line = line "," cols[j]
    print line ",total"

    for (i = 1; i <= nr; i++) {
      line = rows[i]
      for (j = 1; j <= nc; j++) line = line "," (cell[rows[i], cols[j]] + 0)
      print line "," rtot[rows[i]]
    }

    line = "total"
    for (j = 1; j <= nc; j++) line = line "," ctot[cols[j]]
    print line "," (grand + 0)
  }
' "$1"
