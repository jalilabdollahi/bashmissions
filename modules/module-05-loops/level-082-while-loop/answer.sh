#!/usr/bin/env bash
set -euo pipefail

count=1
while [ "$count" -le 3 ]; do
  echo "count=$count"
  ((count += 1))
done
