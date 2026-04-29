# Solution Guide: Plugin System

This level focuses on source files from a dir.

```bash
#!/usr/bin/env bash
set -euo pipefail

mkdir -p plugins
cat > plugins/greet.sh <<'PLUGIN'
greet_plugin(){ echo "plugin=loaded"; }
PLUGIN
for plugin in plugins/*.sh; do source "$plugin"; done
greet_plugin
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
