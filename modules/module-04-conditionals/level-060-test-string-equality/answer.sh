#!/usr/bin/env bash
set -euo pipefail

a="$1"
b="$2"

if [ "$a" = "$b" ]; then
  echo "same"
else
  echo "different"
fi
