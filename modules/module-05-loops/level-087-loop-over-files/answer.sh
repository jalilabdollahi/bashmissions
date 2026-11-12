#!/usr/bin/env bash
# Without nullglob, an unmatched pattern stays as the literal text "logs/*.log".
shopt -s nullglob

for file in logs/*.log; do
  # wc pads its number with spaces on macOS; $(( )) strips them.
  lines=$(( $(wc -l < "$file") ))
  echo "${file##*/}: $lines"
done
