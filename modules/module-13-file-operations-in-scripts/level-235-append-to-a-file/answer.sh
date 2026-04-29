#!/usr/bin/env bash
set -euo pipefail

echo "first" > log.txt
echo "second" >> log.txt
cat log.txt
