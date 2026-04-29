# Solution Guide: Quantifiers

This level focuses on `*`, `+`, `?`, `{n,m}`.

```bash
#!/usr/bin/env bash
set -euo pipefail

code=${1:-}
if [[ $code =~ ^[A-Z]{2}-[0-9]{4}$ ]]; then
  echo "code=valid"
else
  echo "code=invalid"
fi
```

The script keeps the regex focused and prints only the deterministic result expected by the checker.
