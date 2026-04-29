#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp)
echo "temp data" > "$tmp"
cat "$tmp"
rm -f "$tmp"
