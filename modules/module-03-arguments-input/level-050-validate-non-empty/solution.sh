#!/usr/bin/env bash
set -euo pipefail

value="${1:-}"
if [[ -z $value ]]; then
  exit 1
fi

echo "value: $value"
