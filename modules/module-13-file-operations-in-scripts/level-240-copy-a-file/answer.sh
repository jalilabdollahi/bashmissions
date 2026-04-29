#!/usr/bin/env bash
set -euo pipefail

cp fixtures/data.txt copy.txt
if cmp -s fixtures/data.txt copy.txt; then
  echo "copy=ok"
fi
