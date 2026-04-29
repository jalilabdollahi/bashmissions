#!/usr/bin/env bash
set -euo pipefail

mkdir -p logs
touch logs/app.log logs/app.txt logs/error.log
find logs -type f -name '*.log' -printf '%f\n' | sort
