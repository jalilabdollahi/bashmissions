#!/usr/bin/env bash
set -euo pipefail

v="$1"
echo "before: $v"
unset v
echo "after: ${v:-empty}"
