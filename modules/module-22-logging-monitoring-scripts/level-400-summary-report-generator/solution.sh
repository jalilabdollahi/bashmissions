#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
ok=2
fail=1
OUT
cat output.txt
