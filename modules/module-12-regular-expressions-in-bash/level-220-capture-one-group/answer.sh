#!/usr/bin/env bash
set -euo pipefail

# ([^ ]+) is the capture group: one or more characters that are not a space.
# Everything around it is matched but not kept.
re='Failed password for ([^ ]+) from '

while IFS= read -r line || [[ -n $line ]]; do
  if [[ $line =~ $re ]]; then
    # [0] would be the whole matched text; [1] is what the first ( ) caught.
    echo "${BASH_REMATCH[1]}"
  fi
done
