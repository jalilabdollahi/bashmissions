# Solution Guide: Check Dependency Exists

This level focuses on `command -v` guard.

```bash
#!/usr/bin/env bash
set -euo pipefail

if command -v printf > /dev/null; then
  echo "printf=found"
else
  echo "printf=missing"
fi
```

The script demonstrates the failure-handling pattern while keeping the checker output deterministic.
