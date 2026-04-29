# Solution Guide: Redirect Both

This level focuses on `&>`.

```bash
#!/usr/bin/env bash
set -euo pipefail

log=combined.log
{
  echo "stdout: ready"
  echo "stderr: warning" >&2
} &> "$log"
cat "$log"
```

The key is to use the redirection or pipeline operator for the work, then print deterministic output for the mission checker.
