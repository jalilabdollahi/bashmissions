#!/usr/bin/env bash
set -euo pipefail

amount="$1"
parts="$2"

if (( parts == 0 )); then
  echo "parts must be at least 1" >&2
  exit 2
fi

# Integer division already rounds down (for amounts that are not negative).
floor=$(( amount / parts ))

# Add half a part before dividing: a remainder of half or more tips the
# result up to the next whole number, anything less does not.
# With parts=2 the "half" is 1, so 7/2 becomes (7+1)/2 = 4: exact .5 rounds up.
# For an odd divisor such as 3, parts/2 is 1 (rounded down), and that still works:
# a remainder of 2 of 3 (0.67) goes up, a remainder of 1 (0.33) does not.
nearest=$(( (amount + parts / 2) / parts ))

# Adding parts - 1 makes any non-zero remainder push the result up,
# while an exact division stays where it was.
ceiling=$(( (amount + parts - 1) / parts ))

echo "floor=$floor"
echo "nearest=$nearest"
echo "ceiling=$ceiling"
