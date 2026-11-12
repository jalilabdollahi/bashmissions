#!/usr/bin/env bash
set -euo pipefail

token=${1-}
decoded=""

# Positions run from 0 to length-1, so start at the last one and count down.
# For an empty token the start index is -1 and the loop body never runs.
for (( i = ${#token} - 1; i >= 0; i-- )); do
  decoded+=${token:i:1}     # append the single character at position i
done

echo "$decoded"
