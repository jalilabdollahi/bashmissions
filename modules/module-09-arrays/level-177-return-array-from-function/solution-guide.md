# Solution Guide: Return Array from Function

This level focuses on output parsing.

```bash
#!/usr/bin/env bash
set -euo pipefail

make_items() {
  printf '%s\n' alpha beta gamma
}

mapfile -t items < <(make_items)
echo "items=${items[*]}"
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
