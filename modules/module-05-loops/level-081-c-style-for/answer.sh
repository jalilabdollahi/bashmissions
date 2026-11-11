#!/usr/bin/env bash
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh SECONDS" >&2
  exit 2
fi

seconds=$1
# Three parts between the double parentheses: start; keep going while; after each round.
for (( i = seconds; i >= 1; i-- )); do
  echo "T-$i"
done
echo "deploy!"
