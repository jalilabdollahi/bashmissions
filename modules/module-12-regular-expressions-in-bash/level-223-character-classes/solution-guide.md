# Solution Guide: Character Classes

This level focuses on `[a-z]`, `[[:alpha:]]`.

```bash
#!/usr/bin/env bash
set -euo pipefail

word=${1:-}
if [[ $word =~ ^[[:alpha:]]+$ ]]; then
  echo "alpha=yes"
else
  echo "alpha=no"
fi
```

The script keeps the regex focused and prints only the deterministic result expected by the checker.
