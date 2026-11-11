#!/usr/bin/env bash
set -euo pipefail

# make_bar WORD: leaves a row of # (one per character of WORD) in $bar
make_bar() {
  # The bug: this loop used to count with the name "count", the very name the
  # main script uses for its running number. Without "local" the function
  # reached out and counted the caller's variable down to zero.
  local n=${#1}
  bar=""                       # deliberate global: this is how we hand the result back
  while (( n > 0 )); do
    bar+="#"
    n=$(( n - 1 ))
  done
}

count=0
for site in "$@"; do
  count=$(( count + 1 ))
  make_bar "$site"
  echo "$count. $site $bar"
done
echo "total: $count"
