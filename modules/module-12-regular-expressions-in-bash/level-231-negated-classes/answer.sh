#!/usr/bin/env bash
set -euo pipefail

# ERE has no lazy ".*?", so we do not ask for "as little as possible".
# We say what the text IS: any run of characters that are not a double quote.
# [^"]* cannot cross a quote, so it stops at the first closing one by construction.
# The regex sits in a variable in single quotes, which also keeps the " readable.
re='msg="([^"]*)"'

while IFS= read -r line || [[ -n $line ]]; do
  if [[ $line =~ $re ]]; then
    echo "msg: ${BASH_REMATCH[1]}"
  else
    echo "no msg"
  fi
done
