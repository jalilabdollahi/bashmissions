#!/usr/bin/env bash
set -euo pipefail

value=${1:-}
if [[ $value =~ ^[0-9]+$ ]]; then
  echo "number"
else
  echo "not-number"
fi
