#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
load=checked
OUT
cat output.txt
