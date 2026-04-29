#!/usr/bin/env bash
set -euo pipefail
sort -t, -k1,1 -u fixtures/data.csv
