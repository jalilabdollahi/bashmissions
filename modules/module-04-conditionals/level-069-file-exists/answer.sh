#!/usr/bin/env bash
set -euo pipefail

path="$1"

if [ -f "$path" ]; then
  echo "file"
elif [ -d "$path" ]; then
  echo "directory"
else
  echo "missing"
fi
