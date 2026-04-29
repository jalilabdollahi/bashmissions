#!/usr/bin/env bash
set -euo pipefail

str="$1"
if [[ $str =~ ^user:([A-Za-z0-9_]+)$ ]]; then
  echo "name=${BASH_REMATCH[1]}"
else
  echo "no match"
fi
