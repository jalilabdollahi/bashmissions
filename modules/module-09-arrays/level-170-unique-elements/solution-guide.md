# Solution Guide: Unique Elements

This level focuses on sort + uniq trick.

```bash
#!/usr/bin/env bash
set -euo pipefail

items=(beta alpha beta gamma alpha)
mapfile -t unique < <(printf '%s\n' "${items[@]}" | sort | uniq)
printf '%s\n' "${unique[@]}"
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
