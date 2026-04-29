#!/usr/bin/env bash
set -euo pipefail

value=${1:-}
if [[ $value =~ ^ID-[0-9]+$ ]]; then
  echo "anchored=match"
else
  echo "anchored=no-match"
fi
