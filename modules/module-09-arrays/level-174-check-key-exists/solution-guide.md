# Solution Guide: Check Key Exists

This level focuses on `[[ -v map[key] ]]`.

```bash
#!/usr/bin/env bash
set -euo pipefail

key=${1:-}
declare -A colors=([red]=1 [blue]=1)
if [[ -n $key && -v colors[$key] ]]; then
  echo exists
else
  echo missing
fi
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
