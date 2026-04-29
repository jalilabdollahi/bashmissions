# Solution Guide: Match a Number

This level focuses on `^[0-9]+$`.

```bash
#!/usr/bin/env bash
set -euo pipefail

value=${1:-}
if [[ $value =~ ^[0-9]+$ ]]; then
  echo "number"
else
  echo "not-number"
fi
```

The script keeps the regex focused and prints only the deterministic result expected by the checker.
