#!/usr/bin/env bash
set -euo pipefail

config=fixtures/app.conf
mode=unknown
load_config(){ source "$config"; }
trap 'load_config; echo "mode=$mode"' HUP
load_config
echo "mode=$mode"
echo "mode=reloaded" > "$config"
kill -HUP $$
