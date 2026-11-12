#!/usr/bin/env bash
set -euo pipefail

name=${1-}
result=""

# Unquoted $name is split on whitespace, so each turn of the loop gets ONE word
# and runs of spaces collapse. That is what we want here.
for word in $name; do
  word=${word,,}                      # first flatten everything to lower case
  result+="${result:+ }${word^}"      # add a space (except before the first word), then Capitalise
done

echo "$result"
