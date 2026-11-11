#!/usr/bin/env bash
set -euo pipefail

log=$1 n=$2

echo "Top $n NXDOMAIN names"

awk '$4 == "NXDOMAIN" { print $3 }' "$log" |   # one name per failed query
  sort |                                       # equal names side by side
  uniq -c |                                    # "   3 name"
  sed 's/^ *//' |                              # same shape on macOS and Linux
  sort -k1,1nr -k2,2 |                         # most queried first, ties by name
  head -n "$n" |                               # the top N
  awk '{ printf "%d. %s (%d)\n", NR, $2, $1 }' # NR numbers the ranking
