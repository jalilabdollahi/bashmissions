#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
memory=checked
OUT
cat output.txt
