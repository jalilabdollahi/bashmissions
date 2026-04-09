#!/usr/bin/env bash
set -euo pipefail

input=${1:-}
mode=${2:-ok}

[ -f "$input" ] || exit 1
printf '%s\n' 'the-observability-kit:496:expert:'"$mode"
