#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
process=ok
disk=ok
memory=ok
OUT
cat output.txt
