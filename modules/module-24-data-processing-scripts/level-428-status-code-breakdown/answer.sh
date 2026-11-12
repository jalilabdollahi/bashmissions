#!/usr/bin/env bash
set -euo pipefail

awk '
  { sub(/\r$/, "") }
  $0 == "" { next }

  {
    total++
    if ($4 ~ /^[1-5][0-9][0-9]$/) cls = substr($4, 1, 1) "xx"
    else                          cls = "other"
    count[cls]++
  }

  END {
    # A fixed list of names keeps the report the same shape every time:
    # for (k in count) would skip empty classes and shuffle the order.
    n = split("1xx 2xx 3xx 4xx 5xx other", names, " ")
    for (i = 1; i <= n; i++) {
      c = count[names[i]] + 0          # +0: an unseen class counts as 0
      pct = (total > 0) ? 100 * c / total : 0
      printf "%s %d %.1f%%\n", names[i], c, pct
    }
    printf "total %d\n", total + 0
  }
' "$1"
