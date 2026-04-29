#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
removed=old.log
OUT
cat result.txt
