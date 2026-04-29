# Solution Guide: Debug Log Function

This level focuses on conditional `DEBUG` variable.

```bash
#!/usr/bin/env bash
set -euo pipefail

DEBUG=1
debug() {
  if [[ $DEBUG == 1 ]]; then
    printf 'DEBUG: %s\n' "$*"
  fi
}
debug "loading config"
echo "run=ok"
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
