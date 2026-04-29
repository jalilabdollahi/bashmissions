#!/usr/bin/env bash
set -euo pipefail

if [[ $1 == *.txt ]]; then
  echo "text file"
else
  echo "other"
fi
