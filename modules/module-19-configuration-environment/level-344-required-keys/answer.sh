#!/usr/bin/env bash
set -euo pipefail

if (( $# < 2 )); then
  echo "usage: solution.sh CONFIG_FILE KEY..." >&2
  exit 2
fi
file=$1
shift                       # from here on "$@" is the list of required keys
if [[ ! -r $file ]]; then
  echo "cannot read $file" >&2
  exit 2
fi

declare -A value
while IFS='=' read -r key rest || [[ -n $key ]]; do
  key=${key#"${key%%[![:space:]]*}"};   key=${key%"${key##*[![:space:]]}"}
  rest=${rest:-}
  rest=${rest#"${rest%%[![:space:]]*}"}; rest=${rest%"${rest##*[![:space:]]}"}
  [[ -n $key && $key != \#* ]] || continue
  value[$key]=$rest                      # a later line overwrites an earlier one
done < "$file"

missing=0
for key in "$@"; do
  if [[ -z ${value[$key]:-} ]]; then     # absent and empty look the same here
    echo "missing: $key" >&2
    missing=$(( missing + 1 ))
  fi
done

if (( missing > 0 )); then
  echo "config invalid: $missing of $# required keys missing" >&2
  exit 1
fi
echo "config ok: $# required keys present"
