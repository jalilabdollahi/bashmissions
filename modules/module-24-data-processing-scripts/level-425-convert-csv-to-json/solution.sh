#!/usr/bin/env bash
set -euo pipefail
awk -F, 'NR==2{printf "{\"name\":\"%s\",\"score\":%s}\n",$1,$2}' fixtures/data.csv
