#!/usr/bin/env bash
set -euo pipefail

i="$1"
((i += 5))
((i *= 2))
echo "value=$i"
