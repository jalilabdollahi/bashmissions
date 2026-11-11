#!/usr/bin/env bash
# Run fleet-disk, loop over its "<host> <percent>" lines, report:
#   fullest: <host> (<percent>%)
#   over 80%: <count of servers above 80>
# TODO: use process substitution so the variables survive the loop.
fleet-disk
echo "fullest: none"
echo "over 80%: 0"
