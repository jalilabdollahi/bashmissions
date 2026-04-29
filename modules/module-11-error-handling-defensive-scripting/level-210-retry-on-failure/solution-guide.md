# Solution Guide: Retry on Failure

This level focuses on loop with counter.

```bash
#!/usr/bin/env bash
set -euo pipefail

attempt=1
while (( attempt <= 3 )); do
  if (( attempt == 3 )); then
    echo "success_on=$attempt"
    break
  fi
  echo "retry=$attempt"
  ((attempt++))
done
```

The script demonstrates the failure-handling pattern while keeping the checker output deterministic.
