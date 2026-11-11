#!/usr/bin/env bash
for code in "$@"; do
  # No quotes around the pattern: the star must stay a wildcard.
  if [[ $code == TEST-* ]]; then
    continue   # abandon this round, go straight to the next code
  fi
  echo "billing $code"
done
