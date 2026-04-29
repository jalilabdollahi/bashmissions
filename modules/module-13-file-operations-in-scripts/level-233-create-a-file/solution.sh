#!/usr/bin/env bash
set -euo pipefail

touch created.txt
echo "exists=$([[ -f created.txt ]] && echo yes || echo no)"
echo "bytes=$(wc -c < created.txt)"
