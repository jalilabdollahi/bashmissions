# Solution Guide: Per-User Config

This level focuses on `~/.config/app/config`.

```bash
#!/usr/bin/env bash
set -euo pipefail

HOME=$PWD/home
config_dir="$HOME/.config/app"
mkdir -p "$config_dir"
echo "theme=dark" > "$config_dir/config"
cat "$config_dir/config"
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
