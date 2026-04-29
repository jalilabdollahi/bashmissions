# Solution Guide: Cleanup Temp Files

This level focuses on trap + mktemp.

```bash
#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp)
trap 'rm -f "$tmp"; echo "temp=removed"' EXIT
echo "temp=created"
```

The script demonstrates the failure-handling pattern while keeping the checker output deterministic.
