# Solution Guide: Pass Array to Function

This level focuses on nameref `declare -n`.

```bash
#!/usr/bin/env bash
set -euo pipefail

summarize() {
  local -n ref=$1
  echo "count=${#ref[@]}"
  echo "first=${ref[0]}"
}

items=(alpha beta gamma)
summarize items
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
