#!/usr/bin/env bash
# Count the rehearsals the script made: binary search needs at most
# 1 + ceil(log2 N) of them.
n=$(( $(wc -l < steps.txt) ))
bound=1; size=1
while (( size < n )); do size=$(( size * 2 )); bound=$(( bound + 1 )); done
calls=0
[[ -f .calls.log ]] && calls=$(( $(wc -l < .calls.log) ))
if (( calls > bound )); then
  echo "You ran try-steps $calls times for $n steps; a binary search needs at most $bound."
  echo "Halve the range each time instead of walking through the steps one by one."
  exit 1
fi
exit 0
