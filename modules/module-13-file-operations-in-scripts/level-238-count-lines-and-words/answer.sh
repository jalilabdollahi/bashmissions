#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh FILE..." >&2
  exit 2
fi

total_lines=0
total_words=0

for f in "$@"; do
  if [[ ! -f $f ]]; then
    echo "skipping $f (not a file)" >&2
    continue
  fi
  # "< file" means wc sees no file name and prints just the number.
  # $(( )) turns "      12" (macOS) into plain 12.
  lines=$(( $(wc -l < "$f") ))
  words=$(( $(wc -w < "$f") ))
  echo "$f: $lines lines, $words words"
  total_lines=$(( total_lines + lines ))
  total_words=$(( total_words + words ))
done

echo "total: $total_lines lines, $total_words words"
