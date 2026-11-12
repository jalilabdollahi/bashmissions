#!/usr/bin/env bash
set -euo pipefail

# extglob adds patterns like +( ... ) = "one or more of these".
shopt -s extglob

# IFS= stops read from trimming for us, so the work below is visible and explicit.
while IFS= read -r line || [[ -n $line ]]; do
  line=${line##+([[:space:]])}   # longest run of whitespace at the start
  line=${line%%+([[:space:]])}   # longest run of whitespace at the end
  echo "[$line]"
done
