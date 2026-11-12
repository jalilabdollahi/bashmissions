#!/usr/bin/env bash
set -euo pipefail

while IFS= read -r line || [[ -n $line ]]; do
  if [[ $line =~ ^$ ]]; then          # start immediately followed by end: empty line
    echo blank
  elif [[ $line =~ ^# ]]; then        # '#' must be the very first character
    echo comment
  elif [[ $line =~ \ yes$ ]]; then    # ' yes' must be the very last thing
    echo risky
  else
    echo other
  fi
done
