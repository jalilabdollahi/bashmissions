#!/usr/bin/env bash
set -euo pipefail

# stats N...  - prints three values on ONE line: min max sum
stats() {
  local min=$1 max=$1 sum=0 n
  for n in "$@"; do
    (( n < min )) && min=$n
    (( n > max )) && max=$n
    sum=$(( sum + n ))
  done
  printf '%s %s %s\n' "$min" "$max" "$sum"
}

if [[ $# -eq 0 ]]; then
  echo "no numbers given" >&2
  exit 1
fi

# $( ) captures the line, <<< feeds it to read, read splits on spaces.
read -r min max sum <<< "$(stats "$@")"
echo "min=$min max=$max sum=$sum"
