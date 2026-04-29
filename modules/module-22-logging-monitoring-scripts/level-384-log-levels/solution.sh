#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
INFO ready
WARN disk
OUT
cat output.txt
