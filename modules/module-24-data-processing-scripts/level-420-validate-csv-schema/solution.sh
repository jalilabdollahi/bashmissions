#!/usr/bin/env bash
set -euo pipefail
awk -F, 'NF != 3 {bad++} END {print bad ? "schema=bad" : "schema=ok"}' fixtures/data.csv
