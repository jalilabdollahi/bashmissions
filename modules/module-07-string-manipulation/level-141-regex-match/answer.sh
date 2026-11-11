#!/usr/bin/env bash
set -euo pipefail

# ^ and $ pin the match to the whole line; [0-9]+ is "one or more digits";
# \. is a literal dot (an unescaped . would match any character).
# Keeping the regex in a variable avoids quoting surprises in [[ ]].
re='^v?[0-9]+\.[0-9]+\.[0-9]+$'

while IFS= read -r tag || [[ -n $tag ]]; do
  if [[ $tag =~ $re ]]; then
    echo "$tag: valid"
  else
    echo "$tag: invalid"
  fi
done
