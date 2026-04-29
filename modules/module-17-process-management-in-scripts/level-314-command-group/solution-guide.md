# Solution Guide: Command Group

This level focuses on `{ ... }`.

```bash
#!/usr/bin/env bash
set -euo pipefail

{
  echo alpha
  echo beta
} > grouped.txt
cat grouped.txt
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
