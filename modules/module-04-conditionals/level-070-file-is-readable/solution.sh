#!/usr/bin/env bash
set -euo pipefail

if [ -r "$1" ]; then
  echo "readable"
else
  echo "not readable"
fi
