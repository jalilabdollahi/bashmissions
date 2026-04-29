# Solution Guide: Trap on SIGTERM

This level focuses on handle kill signal.

```bash
#!/usr/bin/env bash
set -euo pipefail

(
  trap 'echo "sigterm=handled"; exit 0' TERM
  kill -TERM "$BASHPID"
)
```

The script demonstrates the failure-handling pattern while keeping the checker output deterministic.
