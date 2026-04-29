# Solution Guide: Process Substitution Input

This level focuses on `cmd <(other_cmd)`.

```bash
#!/usr/bin/env bash
set -euo pipefail

if diff <(printf '%s\n' alpha beta) <(printf '%s\n' alpha beta) > /dev/null; then
  echo "streams match"
else
  echo "streams differ"
fi
```

The key is to use the redirection or pipeline operator for the work, then print deterministic output for the mission checker.
