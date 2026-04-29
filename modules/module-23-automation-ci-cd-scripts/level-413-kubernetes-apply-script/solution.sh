#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
kube_apply=stub
OUT
cat result.txt
