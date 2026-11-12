#!/usr/bin/env bash
if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh SERVERS MONTHS" >&2
  exit 2
fi

servers=$1
months=$2

for (( s = 1; s <= servers; s++ )); do
  printf 'servers %d:' "$s"
  # The inner loop starts again from 1 for every server (every row).
  for (( m = 1; m <= months; m++ )); do
    printf '%6d' $(( s * m * 12 ))
  done
  # Finish the row. This runs once per outer round, after the inner loop.
  printf '\n'
done
