#!/usr/bin/env bash
set -euo pipefail

awk -F, 'NR > 1 {print $1 ":" $3}' fixtures/data.txt
