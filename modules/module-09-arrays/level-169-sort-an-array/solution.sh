#!/usr/bin/env bash
# Sort tool: MODE (alpha or num) then items. Print the items sorted, one per
# line. The array must go out to "sort" and come back as an array.
mode=${1:-}
if [[ $mode != alpha && $mode != num ]]; then
  echo "usage: solution.sh alpha|num ITEM..." >&2
  exit 2
fi
shift
items=("$@")

# TODO: send the items through sort (numeric for "num") and load the result
#       into an array called sorted. Careful with an empty list!
sorted=("${items[@]}")

# TODO: print the sorted items, one per line (nothing for an empty list)
printf '%s\n' "${sorted[@]}"
