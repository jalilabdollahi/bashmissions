# Solution Guide: Check Job Still Running

This level focuses on `kill -0 $pid`.

```bash
#!/usr/bin/env bash
set -euo pipefail

sleep 0.3 &
pid=$!
if kill -0 "$pid" 2>/dev/null; then
  echo "running=yes"
fi
kill "$pid" 2>/dev/null || true
wait "$pid" 2>/dev/null || true
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
