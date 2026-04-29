#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
bash=found
curl=found
OUT
cat result.txt
