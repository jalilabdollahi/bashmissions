#!/usr/bin/env bash
set -euo pipefail

dir=$(mktemp -d)
echo "inside" > "$dir/item.txt"
echo "dir=$([[ -d $dir ]] && echo yes || echo no)"
echo "file=$(cat "$dir/item.txt")"
rm -rf "$dir"
