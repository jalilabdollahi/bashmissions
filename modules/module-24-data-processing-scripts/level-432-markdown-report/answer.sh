#!/usr/bin/env bash
set -euo pipefail

awk -F, '
  # "|" separates columns in a Markdown table, so a literal one in a name
  # must become "\|". Done with index() because gsub replacement strings with
  # backslashes behave differently in different awks.
  function mdesc(s,    out, p) {
    out = ""
    while ((p = index(s, "|")) > 0) {
      out = out substr(s, 1, p - 1) "\\|"
      s = substr(s, p + 1)
    }
    return out s
  }

  { sub(/\r$/, "") }
  $0 == "" { next }
  NR == 1  { next }

  $3 !~ /^[0-9]+$/ || $4 !~ /^[0-9]+$/ {
    printf "skipped line %d\n", NR > "/dev/stderr"
    next
  }

  {
    total++
    if ($3 + 0 <= $4 + 0) {
      n++
      sku[n]  = $1
      line[n] = "| " $1 " | " mdesc($2) " | " $3 " | " $4 " |"
    }
  }

  END {
    # insertion sort by SKU, keeping the two arrays in step
    for (i = 2; i <= n; i++) {
      ks = sku[i]; kl = line[i]
      for (j = i - 1; j >= 1 && sku[j] "" > ks ""; j--) { sku[j + 1] = sku[j]; line[j + 1] = line[j] }
      sku[j + 1] = ks; line[j + 1] = kl
    }

    print "# Low stock report"
    print ""
    if (n > 0) {
      print "| SKU | Item | Stock | Reorder at |"
      print "|---|---|---:|---:|"
      for (i = 1; i <= n; i++) print line[i]
    } else {
      print "_Nothing to reorder._"
    }
    print ""
    printf "%d of %d item(s) need reordering.\n", n, total
  }
' "$1"
