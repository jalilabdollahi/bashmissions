#!/usr/bin/env bash
set -euo pipefail

key=$1

if (( ${#key} < 4 )); then
  echo "key too short" >&2
  exit 1
fi

# The space before -4 is required: ${key:-4} would mean "default value 4".
last4=${key: -4}

echo "masked=****$last4"
