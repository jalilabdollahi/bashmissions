#!/usr/bin/env bash
set -euo pipefail

read -r -a words < "$1"
last_index=$((${#words[@]} - 1))
printf 'count=%s first=%s last=%s
' "${#words[@]}" "${words[0]}" "${words[$last_index]}"
