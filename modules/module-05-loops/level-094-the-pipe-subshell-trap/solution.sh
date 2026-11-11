#!/usr/bin/env bash
# Theo's script: count the hosts in state "down". It always reports 0 of 0.
# Why? Fix it: no pipe into the loop; give the loop its input with a redirect.
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh FLEETFILE" >&2
  exit 2
fi

total=0
down=0
cat "$1" | while read -r host state; do
  total=$(( total + 1 ))
  if [[ $state == down ]]; then
    down=$(( down + 1 ))
  fi
done
echo "down: $down of $total"
