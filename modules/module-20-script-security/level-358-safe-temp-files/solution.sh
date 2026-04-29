#!/usr/bin/env bash
set -euo pipefail
tmp=$(mktemp)
echo data > "$tmp"
echo "created=$([[ -f $tmp ]] && echo yes || echo no)"
rm -f "$tmp"
