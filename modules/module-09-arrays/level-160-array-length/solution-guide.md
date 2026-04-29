# Solution Guide: Array Length

This level focuses on `${#arr[@]}`.

```bash
#!/usr/bin/env bash
set -euo pipefail

servers=(api web worker cache)
echo "count=${#servers[@]}"
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
