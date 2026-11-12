#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: solution.sh FOLDER PATTERN" >&2
  exit 2
fi
folder=$1
pattern=$2

if [[ ! -d $folder ]]; then
  echo "no such folder: $folder" >&2
  exit 1
fi

# Quotes keep the shell from expanding "*.conf" against the current folder:
# find must receive the pattern itself and match it against every name.
matches=$(find "$folder" -name "$pattern" | sort)

if [[ -n $matches ]]; then
  echo "$matches"
  count=$(( $(echo "$matches" | wc -l) ))
else
  count=0
fi
echo "found: $count"
