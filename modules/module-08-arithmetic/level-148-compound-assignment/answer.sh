#!/usr/bin/env bash
set -euo pipefail

start="$1"
add="$2"
months="$3"

steady="$start"
doubling="$start"

echo "start=$start"

for (( month = 1; month <= months; month++ )); do
  # "x += n" is shorthand for "x = x + n"; "x *= n" for "x = x * n".
  # Using them as plain statements (not inside $(( ))) updates the variable in place.
  (( steady += add ))
  (( doubling *= 2 ))
  echo "month $month: steady=$steady doubling=$doubling"
done
