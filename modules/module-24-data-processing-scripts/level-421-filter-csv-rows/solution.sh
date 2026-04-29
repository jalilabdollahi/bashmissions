#!/usr/bin/env bash
set -euo pipefail
awk -F, 'NR > 1 && $3 > 100 {print $1}' fixtures/data.csv
