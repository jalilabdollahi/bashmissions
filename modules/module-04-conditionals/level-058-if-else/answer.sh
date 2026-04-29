#!/usr/bin/env bash
set -euo pipefail

if [ "$1" = "on" ]; then
  echo "enabled"
else
  echo "disabled"
fi
