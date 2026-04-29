# Guide for Log Function

Goal: Define a log function that prefixes a message with today in `YYYY-MM-DD` format. Print a line matching `[YYYY-MM-DD] deploy`.

Work in this order:

1. Define the function needed for the level.
2. Use the function pattern from this concept: log with timestamp.
3. Call the function with quoted arguments when values may contain spaces.
4. Match stdout and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

log() {
  local message="$1"
  printf '[%s] %s\n' "$(date +%Y-%m-%d)" "$message"
}

log "deploy"
```
