# Solution Guide: Anchors

This level focuses on `^` and `$`.

```bash
#!/usr/bin/env bash
set -euo pipefail

value=${1:-}
if [[ $value =~ ^ID-[0-9]+$ ]]; then
  echo "anchored=match"
else
  echo "anchored=no-match"
fi
```

The script keeps the regex focused and prints only the deterministic result expected by the checker.
