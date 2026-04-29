#!/usr/bin/env bash
set -euo pipefail

os=$(uname -s)

if [ "$os" = "Linux" ]; then
  echo "Linux"
elif [ "$os" = "Darwin" ]; then
  echo "macOS"
else
  echo "Other"
fi
