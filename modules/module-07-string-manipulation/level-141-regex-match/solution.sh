#!/usr/bin/env bash
set -euo pipefail

str="$1"
if [[ $str =~ ^[0-9]{3}$ ]]; then
  echo "match"
else
  echo "no match"
fi
