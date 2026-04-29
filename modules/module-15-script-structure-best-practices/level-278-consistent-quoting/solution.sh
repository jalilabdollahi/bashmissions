#!/usr/bin/env bash
set -euo pipefail

file="two words.txt"
printf 'ok\n' > "$file"
printf 'content=%s\n' "$(< "$file")"
