#!/usr/bin/env bash
set -euo pipefail

mkdir -p plugins
cat > plugins/greet.sh <<'PLUGIN'
greet_plugin(){ echo "plugin=loaded"; }
PLUGIN
for plugin in plugins/*.sh; do source "$plugin"; done
greet_plugin
