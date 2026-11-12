#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh HOST..." >&2
  exit 2
fi

# Background jobs cannot hand variables back to us, but they can write files.
tmp=$(mktemp -d)

n=0
for host in "$@"; do
  n=$((n + 1))
  # 2>&1 so error messages end up in the same file as the normal output.
  latency "$host" > "$tmp/$n" 2>&1 &
done
wait

# Reading in the order of the numbers gives a report in argument order,
# whichever job happened to finish first. (A plain wait returns 0 even when
# some probes failed, so set -e does not interfere.)
for ((i = 1; i <= n; i++)); do
  cat "$tmp/$i"
done

rm -rf "$tmp"
echo "checked $# hosts"
