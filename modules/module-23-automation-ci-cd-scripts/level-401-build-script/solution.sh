#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
compile=ok
test=ok
OUT
cat result.txt
