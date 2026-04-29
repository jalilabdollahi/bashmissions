# Solution Guide: Remove Element

This level focuses on `unset arr[i]`.

```bash
#!/usr/bin/env bash
set -euo pipefail

colors=(red green blue)
unset 'colors[1]'
printf '%s\n' "${colors[@]}"
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
