# Solution Guide: XDG Base Dirs

This level focuses on `$XDG_CONFIG_HOME`.

```bash
#!/usr/bin/env bash
set -euo pipefail

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
echo "config=$XDG_CONFIG_HOME/bashmissions/config"
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
