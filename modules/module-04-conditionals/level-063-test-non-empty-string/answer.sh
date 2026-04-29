#!/usr/bin/env bash
set -euo pipefail

value="${1:-}"

if [ -n "$value" ]; then
  echo "present"
else
  echo "missing"
fi
