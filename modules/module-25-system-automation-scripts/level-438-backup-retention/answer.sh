#!/usr/bin/env bash
set -euo pipefail

dry=0
if [[ ${1:-} == "-n" ]]; then
  dry=1
  shift
fi
if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh [-n] DIR" >&2
  exit 2
fi
dir=$1
if [[ ! -d $dir ]]; then
  echo "no such directory: $dir" >&2
  exit 1
fi

# nullglob: with no matches the array is empty instead of holding the literal pattern.
shopt -s nullglob
archives=("$dir"/*.tar.gz)    # glob results come back sorted, oldest first
total=${#archives[@]}
newest_from=$(( total - 7 ))  # indexes >= this are among the 7 newest

kept=0
deleted=0
for i in "${!archives[@]}"; do
  path=${archives[i]}
  name=${path##*/}
  if (( i >= newest_from )); then
    echo "keep $name (daily)"
    kept=$(( kept + 1 ))
  elif [[ $name == *-Sun.tar.gz ]]; then
    echo "keep $name (weekly)"
    kept=$(( kept + 1 ))
  else
    if (( dry )); then
      echo "would delete $name"
    else
      echo "delete $name"
      rm -f -- "$path"
    fi
    deleted=$(( deleted + 1 ))
  fi
done

if (( dry )); then
  echo "kept $kept, would delete $deleted"
else
  echo "kept $kept, deleted $deleted"
fi
