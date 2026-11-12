#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh FILE" >&2
  exit 2
fi
file=$1

if [[ ! -r $file ]]; then
  echo "no such file: $file" >&2
  exit 1
fi

# -t removes the newline at the end of every line, so elements are clean.
# Without it each element would end in "\n".
mapfile -t hosts < "$file"

echo "loaded: ${#hosts[@]}"
if (( ${#hosts[@]} == 0 )); then
  echo "first: (none)"
  echo "last: (none)"
else
  echo "first: ${hosts[0]}"
  echo "last: ${hosts[-1]}"
fi
