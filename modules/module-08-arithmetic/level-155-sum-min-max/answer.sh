#!/usr/bin/env bash
set -euo pipefail

count=0
sum=0
min=0
max=0

while read -r value; do
  [[ -z $value ]] && continue          # skip blank lines

  if (( count == 0 )); then
    # The first reading is both the smallest and the largest so far.
    # Starting min and max at 0 would be wrong for all-positive or
    # all-negative data.
    min=$value
    max=$value
  else
    if (( value < min )); then min=$value; fi
    if (( value > max )); then max=$value; fi
  fi

  # Plain assignments, because (( count++ )) from 0 would return status 1
  # and set -e would stop the script.
  count=$(( count + 1 ))
  sum=$(( sum + value ))
done

if (( count == 0 )); then
  echo "no data" >&2
  exit 1
fi

echo "count=$count"
echo "sum=$sum"
echo "min=$min"
echo "max=$max"
echo "avg=$(( sum / count ))"
