#!/usr/bin/env bash
# Rack label: the arguments are the machines from the top slot to the bottom.
# Print the top one, the third one (index 2) and the bottom one.
if [[ $# -lt 3 ]]; then
  echo "usage: solution.sh MACHINE MACHINE MACHINE..." >&2
  exit 2
fi

# TODO: put all arguments into an array called rack

# TODO: print the three lines top: / third: / bottom:
# (the last element has a handy negative index)
echo "top: $1"
