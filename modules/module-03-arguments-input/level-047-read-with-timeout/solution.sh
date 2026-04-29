#!/usr/bin/env bash
set -euo pipefail

if read -r -t 1 value < "$1"; then
  echo "read: $value"
else
  echo "timeout"
  exit 1
fi
