# Solution Guide: Timeout Decorator

This level focuses on `timeout` wrapping.

```bash
#!/usr/bin/env bash
set -u

with_timeout(){ timeout 0.1s "$@"; }
with_timeout sleep 1
code=$?
echo "timeout=$code"
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
