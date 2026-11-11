#!/usr/bin/env bash
set -euo pipefail

# ${1-} keeps "set -u" quiet if the caller forgot the argument (it counts as empty).
name=${1-}

# ${#name} is the number of characters in the value. No subprocess needed.
len=${#name}

echo "length=$len"

if (( len < 3 )); then
  echo "status=too-short"
elif (( len > 12 )); then
  echo "status=too-long"
else
  echo "status=ok"
fi
