#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
notify=queued
OUT
cat output.txt
