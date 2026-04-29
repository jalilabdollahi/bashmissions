#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
alert=ERROR
OUT
cat output.txt
