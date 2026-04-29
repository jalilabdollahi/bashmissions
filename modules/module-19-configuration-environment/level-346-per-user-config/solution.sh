#!/usr/bin/env bash
set -euo pipefail

HOME=$PWD/home
config_dir="$HOME/.config/app"
mkdir -p "$config_dir"
echo "theme=dark" > "$config_dir/config"
cat "$config_dir/config"
