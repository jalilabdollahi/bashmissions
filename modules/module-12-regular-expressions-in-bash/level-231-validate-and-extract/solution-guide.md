# Solution Guide: Validate and Extract

This level focuses on combined match + capture.

```bash
#!/usr/bin/env bash
set -euo pipefail

record=${1:-}
if [[ $record =~ ^([a-z]+):([0-9]+)$ ]]; then
  echo "name=${BASH_REMATCH[1]}"
  echo "score=${BASH_REMATCH[2]}"
else
  echo "invalid"
fi
```

The script keeps the regex focused and prints only the deterministic result expected by the checker.
