#!/usr/bin/env bash
set -euo pipefail

# Guard first: -lt means "less than". If fewer than one argument was given,
# explain the correct usage on stderr (>&2) and stop with status 2.
[[ $# -lt 1 ]] && { echo "usage: solution.sh CUSTOMER" >&2; exit 2; }

echo "Looking up customer: $1"
