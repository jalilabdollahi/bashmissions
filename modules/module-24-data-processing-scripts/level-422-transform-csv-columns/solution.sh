#!/usr/bin/env bash
set -euo pipefail
awk -F, 'NR > 1 {print $2 "," $1}' fixtures/data.csv
