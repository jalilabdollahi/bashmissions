#!/usr/bin/env bash
set -euo pipefail

file=$1 wanted=$2
found=0 value=

# IFS='=' makes read split at "=". With two variables, the first gets the text
# before the first "=", and the second gets EVERYTHING that is left, other "="
# signs included. -r keeps backslashes as they are.
# "|| [[ -n $key ]]" handles a last line without a newline: read returns
# failure for it, but the variables are filled.
while IFS='=' read -r key value || [[ -n $key ]]; do
  if [[ $key == "$wanted" ]]; then
    found=1               # keep looping: a later assignment overrides
    result=$value
  fi
done < "$file"

if (( found )); then
  printf '%s\n' "$result"
else
  echo "key not found: $wanted" >&2
  exit 1
fi
