# Solution Guide: Capture Group

This level focuses on `${BASH_REMATCH[1]}`.

```bash
#!/usr/bin/env bash
set -euo pipefail

record="user:alice"
if [[ $record =~ ^user:([a-z]+)$ ]]; then
  echo "name=${BASH_REMATCH[1]}"
fi
```

The script keeps the regex focused and prints only the deterministic result expected by the checker.
