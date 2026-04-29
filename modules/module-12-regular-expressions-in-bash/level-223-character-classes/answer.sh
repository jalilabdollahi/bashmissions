#!/usr/bin/env bash
set -euo pipefail

word=${1:-}
if [[ $word =~ ^[[:alpha:]]+$ ]]; then
  echo "alpha=yes"
else
  echo "alpha=no"
fi
