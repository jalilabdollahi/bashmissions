#!/usr/bin/env bash
set -euo pipefail

in_services=0
while IFS= read -r line; do
  if [[ $line =~ ^\[services\]$ ]]; then
    in_services=1
    continue
  fi
  if [[ $line =~ ^\[.*\]$ ]]; then
    in_services=0
    continue
  fi
  if (( in_services )) && [[ $line =~ ^name=([a-z-]+)$ ]]; then
    echo "service=${BASH_REMATCH[1]}"
  fi
done < fixtures/data.txt
