#!/usr/bin/env bash
set -euo pipefail

# A plain word is already a valid regex: it matches that exact text, anywhere
# in the line, because =~ is not anchored unless we say so.
while IFS= read -r line || [[ -n $line ]]; do
  if [[ $line =~ Failed\ password ]]; then
    echo "ALERT: $line"
  fi
done
