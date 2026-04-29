#!/usr/bin/env bash
set -euo pipefail

code=${1:-}
if [[ $code =~ ^[A-Z]{2}-[0-9]{4}$ ]]; then
  echo "code=valid"
else
  echo "code=invalid"
fi
