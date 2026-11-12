#!/usr/bin/env bash
set -euo pipefail

# The group keeps the | local: ACTION=(DROP|REJECT|DENY) means
# "ACTION= followed by DROP, or REJECT, or DENY".
# ( |$) closes the word: a space or the end of the line must follow,
# otherwise DROPPED would sneak in as DROP.
block_re='ACTION=(DROP|REJECT|DENY)( |$)'
allow_re='ACTION=(ACCEPT|ALLOW)( |$)'

blocked=0 allowed=0 other=0
while IFS= read -r line || [[ -n $line ]]; do
  if [[ $line =~ $block_re ]]; then
    blocked=$(( blocked + 1 ))
  elif [[ $line =~ $allow_re ]]; then
    allowed=$(( allowed + 1 ))
  else
    other=$(( other + 1 ))
  fi
done
echo "blocked=$blocked allowed=$allowed other=$other"
