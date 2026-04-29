#!/usr/bin/env bash
set -euo pipefail

name=${1:-safe}
printf '%s\n' "$name" | grep -q safe
echo "strict=ok"
