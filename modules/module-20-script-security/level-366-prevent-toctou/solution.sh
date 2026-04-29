#!/usr/bin/env bash
set -euo pipefail
tmp=$(mktemp final.XXXXXX)
echo ready > "$tmp"
mv "$tmp" final.txt
cat final.txt
