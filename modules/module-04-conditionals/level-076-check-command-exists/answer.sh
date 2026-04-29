#!/usr/bin/env bash
set -euo pipefail

if command -v "$1" >/dev/null 2>&1; then
  echo "found"
else
  echo "missing"
fi
