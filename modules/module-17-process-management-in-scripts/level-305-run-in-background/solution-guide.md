# Solution Guide: Run in Background

This level focuses on `cmd &`.

```bash
#!/usr/bin/env bash
set -euo pipefail

{ sleep 0.05; echo "background done" > result.txt; } &
wait
cat result.txt
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
