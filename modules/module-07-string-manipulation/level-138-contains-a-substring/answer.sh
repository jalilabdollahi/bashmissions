#!/usr/bin/env bash
set -euo pipefail

word=$1
lineno=0
matches=0

while IFS= read -r line || [[ -n $line ]]; do
  lineno=$((lineno + 1))
  # *"$word"* = anything, then the literal word, then anything.
  # The quotes make the word literal; the stars outside them stay wildcards.
  if [[ $line == *"$word"* ]]; then
    echo "line $lineno: $line"
    matches=$((matches + 1))
  fi
done

echo "matches=$matches"
