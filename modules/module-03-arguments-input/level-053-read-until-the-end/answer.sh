#!/usr/bin/env bash
set -euo pipefail

items=0
total=0

# read succeeds while it manages to fetch a line, so the loop stops at end of input.
# For a last line WITHOUT a newline, read returns failure but still fills the
# variables; "|| [[ -n $cost ]]" gives that final line one more turn.
while read -r name cost || [[ -n $cost ]]; do
  items=$((items + 1))
  total=$((total + cost))
done

echo "items=$items total=$total"
