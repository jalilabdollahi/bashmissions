#!/usr/bin/env bash
set -euo pipefail

value="${1:-}"

if [ -z "$value" ]; then
  echo "empty"
else
  echo "not empty"
fi
