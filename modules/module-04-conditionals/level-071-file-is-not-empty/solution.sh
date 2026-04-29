#!/usr/bin/env bash
set -euo pipefail

if [ -s "$1" ]; then
  echo "not empty"
else
  echo "empty"
fi
