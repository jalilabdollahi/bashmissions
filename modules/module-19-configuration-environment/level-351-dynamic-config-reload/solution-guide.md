# Solution Guide: Dynamic Config Reload

This level focuses on trap SIGHUP to reload.

```bash
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
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
