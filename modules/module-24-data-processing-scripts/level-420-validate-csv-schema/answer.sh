#!/usr/bin/env bash
set -euo pipefail

# The whole check is one pass of awk, so line numbers (NR) are the real ones
# even when blank lines are skipped. awk's exit status becomes ours.
awk -F, '
  { sub(/\r$/, "") }

  NR == 1 {
    if ($0 != "id,opened,priority,subject") {
      print "error: unexpected header: " $0
      fatal = 1
      exit 1                      # jumps to END, which must not print more
    }
    next
  }

  $0 == "" { next }               # blank line: not a row

  {
    rows++
    if (NF != 4) {
      printf "line %d: expected 4 fields, found %d\n", NR, NF
      bad++
    } else if ($1 == "") {
      printf "line %d: empty id\n", NR
      bad++
    } else if ($3 !~ /^(low|normal|high|urgent)$/) {
      printf "line %d: bad priority \"%s\"\n", NR, $3
      bad++
    }
  }

  END {
    if (fatal) exit 1
    if (NR == 0) { print "error: empty file"; exit 1 }
    if (bad > 0) { printf "invalid: %d of %d rows\n", bad, rows; exit 1 }
    printf "valid: %d rows\n", rows
  }
' "$1"
