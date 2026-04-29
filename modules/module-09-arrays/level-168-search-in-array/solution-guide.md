# Solution Guide: Search in Array

This level focuses on loop + grep.

```bash
#!/usr/bin/env bash
set -euo pipefail

needle=${1:-}
items=(alpha beta gamma)
result=missing
for item in "${items[@]}"; do
  if printf '%s\n' "$item" | grep -qx -- "$needle"; then
    result=found
    break
  fi
done
echo "$result"
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
