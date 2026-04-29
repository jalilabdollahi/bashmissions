#!/usr/bin/env bash
set -euo pipefail

awk '{count[$1]++} END {for (k in count) print k "=" count[k]}' fixtures/data.txt | sort
