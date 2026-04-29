#!/usr/bin/env bash
set -euo pipefail

a="$1"
b="$2"
printf 'quotient=%s remainder=%s\n' "$((a / b))" "$((a % b))"
