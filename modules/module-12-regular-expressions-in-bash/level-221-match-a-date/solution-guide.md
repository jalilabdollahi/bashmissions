# Solution Guide: Match a Date

This level focuses on YYYY-MM-DD regex.

```bash
#!/usr/bin/env bash
set -euo pipefail

date=${1:-}
if [[ $date =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
  echo "date=valid"
else
  echo "date=invalid"
fi
```

The script keeps the regex focused and prints only the deterministic result expected by the checker.
