#!/usr/bin/env bash
set -euo pipefail

prefix="$1"

# ** binds tighter than anything else, but the exponent is a calculation,
# so it needs its own parentheses: 2 ** (32 - prefix).
addresses=$(( 2 ** (32 - prefix) ))
hosts=$(( addresses - 2 ))

echo "addresses=$addresses"
echo "hosts=$hosts"
