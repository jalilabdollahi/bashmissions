#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
restart=api
OUT
cat output.txt
