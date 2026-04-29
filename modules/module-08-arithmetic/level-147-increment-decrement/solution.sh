#!/usr/bin/env bash
set -euo pipefail

i="$1"
((i++)) || true
((i--)) || true
((i--)) || true
echo "value=$i"
