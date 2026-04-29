#!/usr/bin/env bash
set -euo pipefail

awk -F, 'NR > 1 {print $3, $1}' fixtures/data.txt | sort -rn | head -2 | awk '{print $2 "=" $1}'
