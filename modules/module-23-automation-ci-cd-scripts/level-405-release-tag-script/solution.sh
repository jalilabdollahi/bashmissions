#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
tag=v1.2.3
OUT
cat result.txt
