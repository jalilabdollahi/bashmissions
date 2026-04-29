#!/usr/bin/env bash
set -euo pipefail

file=${1:?provide a file path}
mapfile -t lines < "$file"
last_index=$((${#lines[@]} - 1))
echo "count=${#lines[@]}"
echo "first=${lines[0]}"
echo "last=${lines[$last_index]}"
