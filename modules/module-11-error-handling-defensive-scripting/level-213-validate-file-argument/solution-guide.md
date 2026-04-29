# Solution Guide: Validate File Argument

This level focuses on must exist and be readable.

```bash
#!/usr/bin/env bash
set -euo pipefail

file=${1:-}
if [[ ! -r $file ]]; then
  echo "file=invalid"
  exit 1
fi
echo "lines=$(wc -l < "$file")"
```

The script demonstrates the failure-handling pattern while keeping the checker output deterministic.
