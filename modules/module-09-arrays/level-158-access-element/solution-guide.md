# Solution Guide: Access Element

This level focuses on `${arr[0]}`.

```bash
#!/usr/bin/env bash
set -euo pipefail

colors=(red green blue)
echo "${colors[0]}"
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
