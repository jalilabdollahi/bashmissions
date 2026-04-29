# Solution Guide: Subshell Variable Isolation

This level focuses on changes don't leak.

```bash
#!/usr/bin/env bash
set -euo pipefail

value="parent"
( value="child"; echo "inside=$value" )
echo "outside=$value"
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
