# Solution Guide: Strategy Pattern

This level focuses on swap algorithm functions.

```bash
#!/usr/bin/env bash
set -euo pipefail

upper(){ tr '[:lower:]' '[:upper:]' <<< "$1"; }
lower(){ tr '[:upper:]' '[:lower:]' <<< "$1"; }
strategy=upper
echo "result=$($strategy Bash)"
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
