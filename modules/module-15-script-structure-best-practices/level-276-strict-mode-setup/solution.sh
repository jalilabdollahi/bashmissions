#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

items=$'alpha\nbeta gamma'
count=0
for item in $items; do
  ((++count))
done
echo "strict=on"
echo "items=$count"
