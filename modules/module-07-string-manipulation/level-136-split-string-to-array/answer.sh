#!/usr/bin/env bash
set -euo pipefail

IFS=, read -r -a parts <<< "$1"
last_index=$((${#parts[@]} - 1))
printf 'count=%s first=%s last=%s\n' "${#parts[@]}" "${parts[0]}" "${parts[$last_index]}"
