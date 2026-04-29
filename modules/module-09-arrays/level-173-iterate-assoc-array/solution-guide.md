# Solution Guide: Iterate Assoc Array

This level focuses on `for k in "${!map[@]}"`.

```bash
#!/usr/bin/env bash
set -euo pipefail

declare -A ports=([web]=80 [ssh]=22 [dns]=53)
mapfile -t keys < <(printf '%s\n' "${!ports[@]}" | sort)
for key in "${keys[@]}"; do
  echo "$key=${ports[$key]}"
done
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
