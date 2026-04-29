# Solution Guide: Strict Mode Combo

This level focuses on `set -euo pipefail`.

```bash
#!/usr/bin/env bash
set -euo pipefail

name=${1:-safe}
printf '%s\n' "$name" | grep -q safe
echo "strict=ok"
```

The script demonstrates the failure-handling pattern while keeping the checker output deterministic.
