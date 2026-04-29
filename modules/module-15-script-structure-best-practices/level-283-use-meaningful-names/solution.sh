#!/usr/bin/env bash
set -euo pipefail

source_file="fixtures/data.txt"
destination_file="result.txt"
cp "$source_file" "$destination_file"
printf 'destination=%s\n' "$destination_file"
printf 'content=%s\n' "$(< "$destination_file")"
