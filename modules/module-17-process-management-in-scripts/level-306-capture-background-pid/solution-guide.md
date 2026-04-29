# Solution Guide: Capture Background PID

This level focuses on `$!`.

```bash
#!/usr/bin/env bash
set -euo pipefail

sleep 0.1 &
pid=$!
if [[ $pid =~ ^[0-9]+$ ]]; then
  echo "pid=captured"
fi
wait "$pid"
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
