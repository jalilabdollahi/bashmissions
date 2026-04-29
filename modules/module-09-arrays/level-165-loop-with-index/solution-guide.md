# Solution Guide: Loop with Index

This level focuses on `for i in "${!arr[@]}"`.

```bash
#!/usr/bin/env bash
set -euo pipefail

colors=(red green blue)
for i in "${!colors[@]}"; do
  echo "$i:${colors[$i]}"
done
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
