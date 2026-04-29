#!/usr/bin/env bash
set -euo pipefail

n=1
while IFS= read -r line; do
  echo "$n:$line"
  ((n++))
done < fixtures/data.txt
