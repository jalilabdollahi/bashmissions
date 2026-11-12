#!/usr/bin/env bash
set -euo pipefail

limit=${2:-3}
if ! [[ $limit =~ ^[1-9][0-9]*$ ]]; then
  echo "usage: solution.sh LOG [N]" >&2
  exit 2
fi

# Stage 1: one line per client "client requests bytes" (%.0f keeps big sums exact).
# Stage 2: sort by bytes descending, then client ascending to break ties.
# Stage 3: number the lines, and stop after N. Doing the cut-off inside awk
#          (instead of head) means sort is never killed by a closed pipe.
awk '
  { sub(/\r$/, "") }
  NF < 3 { next }
  {
    requests[$2]++
    if ($3 ~ /^[0-9]+$/) bytes[$2] += $3
    else if (!($2 in bytes)) bytes[$2] = 0     # "-": the client exists, 0 bytes
  }
  END { for (c in requests) printf "%s %d %.0f\n", c, requests[c], bytes[c] }
' "$1" |
  sort -k3,3nr -k1,1 |
  awk -v limit="$limit" '
    NR <= limit { printf "%d. %s requests=%d bytes=%s\n", NR, $1, $2, $3 }
  '
