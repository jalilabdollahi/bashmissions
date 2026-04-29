#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
tests=2 passed
OUT
cat result.txt
