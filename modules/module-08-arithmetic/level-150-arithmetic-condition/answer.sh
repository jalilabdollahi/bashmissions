#!/usr/bin/env bash
set -euo pipefail

a="$1"
b="$2"
if (( a > b )); then
  echo "greater"
else
  echo "not greater"
fi
