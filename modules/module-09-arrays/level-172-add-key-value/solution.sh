#!/usr/bin/env bash
set -euo pipefail

declare -A scores
scores[alice]=10
scores[bob]=20
echo "alice=${scores[alice]}"
echo "bob=${scores[bob]}"
