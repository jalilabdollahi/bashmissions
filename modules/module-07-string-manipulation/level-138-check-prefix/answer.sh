#!/usr/bin/env bash
set -euo pipefail

str="$1"
if [[ $str == pre* ]]; then
  echo "yes"
else
  echo "no"
fi
