# Solution Guide: File Locking

This level focuses on `flock`.

```bash
#!/usr/bin/env bash
set -euo pipefail

exec 9> job.lock
if flock -n 9; then
  echo "locked" > protected.txt
  echo "lock=acquired"
  cat protected.txt
fi
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
