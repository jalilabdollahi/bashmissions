# Solution Guide: Trap on EXIT

This level focuses on cleanup always runs.

```bash
#!/usr/bin/env bash
set -euo pipefail

trap 'echo cleanup=done' EXIT
echo "work=done"
```

The script demonstrates the failure-handling pattern while keeping the checker output deterministic.
