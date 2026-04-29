#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp final.XXXXXX)
echo "version=2" > "$tmp"
mv "$tmp" config.txt
cat config.txt
