#!/usr/bin/env bash
set -euo pipefail

a="$1"
b="$2"
printf 'diff=%s product=%s\n' "$((a - b))" "$((a * b))"
