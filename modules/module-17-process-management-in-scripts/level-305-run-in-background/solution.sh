#!/usr/bin/env bash
set -euo pipefail

{ sleep 0.05; echo "background done" > result.txt; } &
wait
cat result.txt
