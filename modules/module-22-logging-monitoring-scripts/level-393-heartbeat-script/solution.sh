#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
heartbeat=1
heartbeat=2
OUT
cat output.txt
