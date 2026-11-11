#!/usr/bin/env bash
set -euo pipefail

gb="$1"
rate="$2"
servers="$3"

# -v copies shell values into awk variables, so no shell quoting tricks are
# needed inside the program text. A BEGIN block runs without reading any
# input, which makes awk usable as a pocket calculator.
# The $ in the format is plain text; %.2f always prints
# two decimals (and rounds the third away).
awk -v gb="$gb" -v rate="$rate" -v servers="$servers" 'BEGIN {
  total = gb * rate
  printf "total=$%.2f\n", total
  printf "per_server=$%.2f\n", total / servers
}'
