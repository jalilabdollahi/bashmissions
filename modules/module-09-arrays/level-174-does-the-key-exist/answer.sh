#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh FILE [KEY...]" >&2
  exit 2
fi
file=$1
shift

declare -A settings=()
while IFS= read -r line || [[ -n $line ]]; do
  [[ -z $line || $line == \#* || $line != *=* ]] && continue
  settings[${line%%=*}]=${line#*=}
done < "$file"

for key in "$@"; do
  # -v asks "does this key exist?" and ignores what the value is.
  if [[ ! -v settings[$key] ]]; then
    echo "$key: (not set)"
  elif [[ -z ${settings[$key]} ]]; then
    echo "$key: (empty)"
  else
    echo "$key: ${settings[$key]}"
  fi
done
