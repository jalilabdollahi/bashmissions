# Solution Guide: Wait for Background Job

This level focuses on `wait $pid`.

```bash
#!/usr/bin/env bash
set -euo pipefail

( sleep 0.05; exit 0 ) &
pid=$!
wait "$pid"
echo "wait_status=$?"
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
