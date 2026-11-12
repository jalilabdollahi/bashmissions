#!/usr/bin/env bash
set -euo pipefail

# [A-Z]+          one or more capitals
# [0-9]{3,5}      three to five digits
# (-P[0-9])?      the whole "-P1" group, zero or one time
# [ ]*            any number of trailing spaces (the brackets make the space visible)
re='^[A-Z]+-[0-9]{3,5}(-P[0-9])?[ ]*$'

while IFS= read -r line || [[ -n $line ]]; do
  if [[ $line =~ $re ]]; then
    echo "$line: valid"
  else
    echo "$line: invalid"
  fi
done
