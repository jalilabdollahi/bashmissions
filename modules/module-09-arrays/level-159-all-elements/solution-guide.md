# Solution Guide: All Elements

This level focuses on `${arr[@]}`.

```bash
#!/usr/bin/env bash
set -euo pipefail

items=(red "green leaf" blue)
printf '%s\n' "${items[@]}"
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
