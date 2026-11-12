#!/usr/bin/env bash
set -euo pipefail
rack=("$@")

# "${!rack[@]}" is the list of indexes: 0 1 2 ... With the index we know
# both WHERE a machine is and WHAT it is.
for i in "${!rack[@]}"; do
  if [[ ${rack[i]} == "-" ]]; then
    continue                         # empty slot: skip it, keep counting
  fi
  echo "slot $(( i + 1 )): ${rack[i]}"
done
