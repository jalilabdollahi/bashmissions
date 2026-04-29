#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
promoted=staging
OUT
cat result.txt
