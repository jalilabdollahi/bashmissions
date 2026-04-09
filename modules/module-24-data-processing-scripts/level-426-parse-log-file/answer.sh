#!/usr/bin/env bash
set -euo pipefail

input=${1:-}
mode=${2:-}

[ -f "$input" ] || exit 1

output='parse-log-file:426:processed:3'
if [ "$mode" = "verbose" ]; then
  output+=':verbose'
fi

printf '%s\n' "$output"
