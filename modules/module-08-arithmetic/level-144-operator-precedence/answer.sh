#!/usr/bin/env bash
set -euo pipefail

servers="$1"
base="$2"
gb="$3"
rate="$4"

# * binds tighter than +, so no parentheses are needed for the traffic charge.
echo "per_server=$(( base + gb * rate ))"

# Here the addition must happen BEFORE the multiplication, so we force it.
echo "total=$(( (base + gb * rate) * servers ))"
