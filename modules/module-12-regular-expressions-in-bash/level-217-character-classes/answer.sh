#!/usr/bin/env bash
set -euo pipefail

# One bracket expression = exactly one character out of a set.
#   [a-z]        one lowercase letter
#   [[:digit:]]  one digit (the outer [] is the class syntax, the inner one names the class)
# Written twice, the digit class means "two digits"; the next level has a shorter way.
re='^rack-[a-z][[:digit:]][[:digit:]]$'

while IFS= read -r tag || [[ -n $tag ]]; do
  if [[ $tag =~ $re ]]; then
    echo "$tag: ok"
  else
    echo "$tag: bad"
  fi
done
