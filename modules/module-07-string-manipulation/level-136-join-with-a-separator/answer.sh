#!/usr/bin/env bash
set -euo pipefail

sep=$1
shift                 # what is left in "$@" are the host names
hosts=("$@")          # copy them into an array (one element per argument)

joined=""
for host in "${hosts[@]}"; do
  # ${joined:+$sep} is the separator when joined already has text, else nothing.
  joined+="${joined:+$sep}$host"
done

echo "$joined"
