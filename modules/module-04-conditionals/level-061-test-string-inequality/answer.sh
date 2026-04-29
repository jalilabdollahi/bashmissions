#!/usr/bin/env bash
set -euo pipefail

if [ "$1" != "$2" ]; then
  echo "different"
else
  echo "same"
fi
