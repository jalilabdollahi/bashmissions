#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
cpu=1
mem=2
OUT
cat output.txt
