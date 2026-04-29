#!/usr/bin/env bash
set -euo pipefail

str="$1"
if [[ $str == *.log ]]; then
  echo "yes"
else
  echo "no"
fi
