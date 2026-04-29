# Solution Guide: Sort an Array

This level focuses on `readarray` + `sort`.

```bash
#!/usr/bin/env bash
set -euo pipefail

items=(banana apple cherry)
readarray -t sorted < <(printf '%s\n' "${items[@]}" | sort)
printf '%s\n' "${sorted[@]}"
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
