# Solution Guide: Trap on SIGINT

This level focuses on graceful Ctrl-C.

```bash
#!/usr/bin/env bash
set -euo pipefail

(
  trap 'echo "sigint=handled"; exit 0' INT
  kill -INT "$BASHPID"
)
```

The script demonstrates the failure-handling pattern while keeping the checker output deterministic.
