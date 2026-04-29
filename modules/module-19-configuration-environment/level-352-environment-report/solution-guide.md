# Solution Guide: Environment Report

This level focuses on print all config values.

```bash
#!/usr/bin/env bash
set -euo pipefail

APP_ENV=dev
APP_PORT=8080
printf 'APP_ENV=%s\n' "$APP_ENV"
printf 'APP_PORT=%s\n' "$APP_PORT"
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
