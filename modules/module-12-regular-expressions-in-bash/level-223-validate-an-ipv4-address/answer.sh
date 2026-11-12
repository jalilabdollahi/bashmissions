#!/usr/bin/env bash
set -euo pipefail

# Step 1, the shape: four groups of 1-3 digits, separated by real dots.
re='^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$'

while IFS= read -r addr || [[ -n $addr ]]; do
  ok=yes
  if [[ $addr =~ $re ]]; then
    # Step 2, the meaning: a regex can't say "at most 255", arithmetic can.
    # 10# stops Bash reading 010 as octal (8) and rejecting 08 and 09 outright.
    for octet in "${BASH_REMATCH[@]:1:4}"; do
      if (( 10#$octet > 255 )); then
        ok=no
      fi
    done
  else
    ok=no
  fi

  if [[ $ok == yes ]]; then
    echo "$addr valid"
  else
    echo "$addr invalid"
  fi
done
