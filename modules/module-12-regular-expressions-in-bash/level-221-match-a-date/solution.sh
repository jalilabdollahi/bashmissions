#!/usr/bin/env bash
set -euo pipefail

date=${1:-}
if [[ $date =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
  echo "date=valid"
else
  echo "date=invalid"
fi
