# Solution Guide: Array from Command

This level focuses on `mapfile -t arr < <(cmd)`.

```bash
#!/usr/bin/env bash
set -euo pipefail

mapfile -t names < <(printf '%s\n' alpha beta gamma)
printf '%s\n' "${names[@]}"
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
