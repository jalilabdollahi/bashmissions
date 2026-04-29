# Solution Guide: Send Signal to Self

This level focuses on `kill -USR1 $$`.

```bash
#!/usr/bin/env bash
set -euo pipefail

trap 'echo "usr1=handled"' USR1
kill -USR1 $$
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
