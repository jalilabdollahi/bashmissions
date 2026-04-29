#!/usr/bin/env bash
set -euo pipefail

if [ "$1" -lt "$2" ]; then
  echo "less"
elif [ "$1" -eq "$2" ]; then
  echo "equal"
else
  echo "greater"
fi
