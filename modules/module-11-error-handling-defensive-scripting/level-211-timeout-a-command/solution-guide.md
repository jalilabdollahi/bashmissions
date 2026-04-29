# Solution Guide: Timeout a Command

This level focuses on `timeout` command.

```bash
#!/usr/bin/env bash
set -u

timeout 0.1s sleep 1
code=$?
echo "timeout_exit=$code"
```

The script demonstrates the failure-handling pattern while keeping the checker output deterministic.
