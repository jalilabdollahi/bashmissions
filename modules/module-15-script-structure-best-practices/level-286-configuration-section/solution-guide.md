# Solution Guide: Configuration Section

This level focuses on top-of-script constants.

```bash
#!/usr/bin/env bash
set -euo pipefail

readonly APP_ENV="dev"
readonly RETRIES=3

printf 'env=%s\n' "$APP_ENV"
printf 'retries=%s\n' "$RETRIES"
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
