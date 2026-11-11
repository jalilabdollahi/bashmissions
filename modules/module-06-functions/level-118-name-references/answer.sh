#!/usr/bin/env bash
set -euo pipefail

# add_unique ARRAYNAME VALUE
# "local -n list=$1" makes "list" an alias for the variable whose NAME is in $1.
# Reading or changing list now reads or changes the caller's array.
add_unique() {
  local -n list=$1
  local value=$2 item
  for item in "${list[@]}"; do
    [[ $item == "$value" ]] && return 0      # already there: nothing to do
  done
  list+=("$value")
}

seen=()
while read -r line; do
  [[ -z $line ]] && continue
  add_unique seen "$line"                    # the NAME of the array, no dollar sign
done

echo "unique: ${#seen[@]}"
for item in "${seen[@]}"; do
  echo "- $item"
done
