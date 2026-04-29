#!/usr/bin/env bash
set -euo pipefail
mkdir -p files
touch files/a.txt files/b.txt
for file in files/*.txt; do basename "$file"; done | sort
