#!/usr/bin/env bash
set -euo pipefail

value="$1"
if [[ ! $value =~ ^[0-9]+$ ]]; then
  exit 1
fi

echo "number: $value"
