# Solution Guide: Find Files by Pattern

This level focuses on `find` in script.

```bash
#!/usr/bin/env bash
set -euo pipefail

mkdir -p logs
touch logs/app.log logs/app.txt logs/error.log
find logs -type f -name '*.log' -printf '%f\n' | sort
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
