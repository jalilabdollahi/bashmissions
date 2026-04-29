# Solution Guide: Guard Clause Pattern

This level focuses on early return on bad input.

```bash
#!/usr/bin/env bash
set -euo pipefail

value=${1:-}
if [[ -z $value ]]; then
  echo "missing=value"
  exit 0
fi
echo "value=$value"
```

The script demonstrates the failure-handling pattern while keeping the checker output deterministic.
