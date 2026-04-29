#!/usr/bin/env bash
set -euo pipefail

count=$(wc -l < fixtures/data.txt)
echo "lines=$count"
