#!/usr/bin/env bash
# Rack cabling sheet. Arguments are UNIT=DEVICE pairs (split at the FIRST =).
# An optional first argument --reverse flips the order.
# Print "U<unit>: <device>" sorted by unit NUMBER (10 comes after 2).
reverse=0
if [[ ${1:-} == --reverse ]]; then
  reverse=1
  shift
fi

# TODO: put the pairs in an associative array keyed by unit

# TODO: print the keys in numeric order (reversed when asked)
for pair in "$@"; do
  echo "U${pair%%=*}: ${pair#*=}"
done
