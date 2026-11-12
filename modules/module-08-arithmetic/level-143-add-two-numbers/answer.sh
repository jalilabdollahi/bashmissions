#!/usr/bin/env bash
set -euo pipefail

anchovy_gb="$1"
barracuda_gb="$2"

# $(( ... )) evaluates the expression and is replaced by the result.
# Inside it, variable names need no $ in front.
total=$(( anchovy_gb + barracuda_gb ))

echo "combined: $total GB"
