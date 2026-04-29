#!/usr/bin/env bash
set -euo pipefail

value=${1:-}
if [[ -z $value ]]; then
  echo "missing=value"
  exit 0
fi
echo "value=$value"
