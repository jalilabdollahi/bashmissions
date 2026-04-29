# Solution Guide: Override via Env Var

This level focuses on `${VAR:-config_value}`.

```bash
#!/usr/bin/env bash
set -euo pipefail

config_value=dev
APP_ENV=prod
effective=${APP_ENV:-$config_value}
echo "env=$effective"
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
