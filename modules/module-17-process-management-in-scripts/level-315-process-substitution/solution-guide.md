# Solution Guide: Process Substitution

This level focuses on `<(cmd)`.

```bash
#!/usr/bin/env bash
set -euo pipefail

if diff <(printf '%s\n' a b) <(printf '%s\n' a b) >/dev/null; then
  echo "diff=match"
fi
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
