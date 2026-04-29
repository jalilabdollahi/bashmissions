#!/usr/bin/env bash
set -euo pipefail

total=0
for n in "$@"; do
  ((total += n))
done

echo "sum=$total"
