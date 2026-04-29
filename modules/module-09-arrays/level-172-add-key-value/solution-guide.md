# Solution Guide: Add Key-Value

This level focuses on `map[key]=value`.

```bash
#!/usr/bin/env bash
set -euo pipefail

declare -A scores
scores[alice]=10
scores[bob]=20
echo "alice=${scores[alice]}"
echo "bob=${scores[bob]}"
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
