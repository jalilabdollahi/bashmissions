#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
docker_build=stub
OUT
cat result.txt
