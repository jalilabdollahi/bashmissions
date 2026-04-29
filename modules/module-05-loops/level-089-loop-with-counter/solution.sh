#!/usr/bin/env bash
set -euo pipefail

counter=1
while IFS= read -r line; do
  echo "$counter:$line"
  ((counter += 1))
done < "$1"
