#!/usr/bin/env bash
set -euo pipefail

file="fixtures/data.txt"
if [ -r "$file" ]; then
  printf 'portable=readable\n'
fi
