#!/usr/bin/env bash
set -euo pipefail

readonly NAME="$1"
( NAME="changed" ) 2>/dev/null || true
echo "$NAME"
