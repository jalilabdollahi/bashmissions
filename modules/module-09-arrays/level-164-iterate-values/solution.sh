#!/usr/bin/env bash
# Month-end numbers: the arguments are invoice amounts in whole dollars.
# Print "total: N" (sum of all) and "large: N" (how many are 100 or more).
amounts=("$@")

total=0
large=0

# TODO: loop over every VALUE in the array, add it to total,
#       and count the ones that are 100 or more

echo "total: $total"
echo "large: $large"
