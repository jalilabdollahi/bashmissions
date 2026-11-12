#!/usr/bin/env bash
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh FLEETFILE" >&2
  exit 2
fi
file=$1

total=0
down=0
# The loop runs in the current shell because the file is attached with "<",
# not piped in. So total and down are still ours after "done".
while read -r host state; do
  total=$(( total + 1 ))
  if [[ $state == down ]]; then
    down=$(( down + 1 ))
  fi
done < "$file"

echo "down: $down of $total"
