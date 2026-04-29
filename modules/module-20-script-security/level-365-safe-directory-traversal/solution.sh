#!/usr/bin/env bash
set -euo pipefail
mkdir -p tree
echo ok > tree/real.txt
ln -s real.txt tree/link.txt
for file in tree/*; do
  if [[ -L $file ]]; then
    echo "skip=$(basename "$file")"
  fi
done
