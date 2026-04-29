#!/usr/bin/env bash
set -euo pipefail

lines=$(wc -l < fixtures/data.txt)
printf 'lines=%s\n' "$lines"
