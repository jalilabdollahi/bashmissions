#!/usr/bin/env bash
# Plan census: stdin has one plan name per line. Count each name with an
# associative array and print "<plan>: <count>" sorted by plan name.
# Blank lines are skipped; empty input prints nothing.

# TODO: declare the map

while IFS= read -r plan || [[ -n $plan ]]; do
  # TODO: skip empty lines; add 1 to the counter for this plan
  :
done

# TODO: print the keys in sorted order with their counts
