#!/usr/bin/env bash
set -euo pipefail

# The customers file is listed FIRST so that awk reads it before the invoices.
# While FNR == NR (the per-file line number equals the global one) we are still
# inside that first file, so every line goes into the lookup table.
awk -F, -v OFS=, '
  { sub(/\r$/, "") }
  $0 == "" { next }

  FNR == NR {
    if (FNR > 1 && !($1 in name)) name[$1] = $2     # header skipped, first wins
    next
  }

  FNR == 1 { print "invoice,name,amount"; next }    # header of the invoices

  {
    who = ($2 in name) ? name[$2] : "UNKNOWN"
    print $1, who, $3
  }
' "$2" "$1"
