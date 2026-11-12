#!/usr/bin/env bash
set -euo pipefail

# Splitting on the double quote turns the awkward format into a regular one:
#   $1 = host ident user [date zone]      $2 = METHOD /path PROTO
#   $3 =  status bytes                    $4 = referer   $6 = agent
# and each of those pieces is then split on spaces.
awk -F'"' '
  { sub(/\r$/, "") }
  $0 == "" { next }

  {
    ok = (NF == 7)                     # six quotes -> seven fields
    if (ok) {
      nh = split($1, h, " ")           # host ident user [date zone]
      nr = split($2, r, " ")           # METHOD path PROTO
      ns = split($3, s, " ")           # status bytes
      ok = (nh == 5 && nr == 3 && ns == 2 && s[1] ~ /^[0-9][0-9][0-9]$/)
    }
    if (!ok) {
      printf "bad line %d\n", NR > "/dev/stderr"
      next
    }
    bytes = (s[2] == "-") ? 0 : s[2]
    print h[1], substr(h[4], 2), r[1], r[2], s[1], bytes
  }
' "$1"
