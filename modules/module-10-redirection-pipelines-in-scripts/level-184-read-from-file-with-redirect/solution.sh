#!/usr/bin/env bash
set -euo pipefail

file=${1:?provide a file}
IFS= read -r first < "$file"
echo "first=$first"
