#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
cron=ran
OUT
cat result.txt
