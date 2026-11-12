#!/usr/bin/env bash
set -euo pipefail

# local part : [[:alnum:]._%+-]+     the '-' is last so it is a plain dash, not a range
# separator  : @
# domain     : [[:alnum:].-]+        dots and dashes are allowed inside
# last dot   : \.                    escaped, so it is a real dot
# extension  : [[:alpha:]]{2,}       at least two letters
# The greedy domain part gives back characters until the final \.[[:alpha:]]{2,} fits.
re='^[[:alnum:]._%+-]+@[[:alnum:].-]+\.[[:alpha:]]{2,}$'

while IFS= read -r addr || [[ -n $addr ]]; do
  if [[ $addr =~ $re ]]; then
    echo "OK $addr"
  else
    echo "BAD $addr"
  fi
done
