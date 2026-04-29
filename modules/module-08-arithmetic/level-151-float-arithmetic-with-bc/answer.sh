#!/usr/bin/env bash
set -euo pipefail

a="$1"
b="$2"
result=$(echo "scale=2; $a / $b" | bc)
echo "result=$result"
