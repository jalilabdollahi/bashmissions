# Solution Guide: Subshell

This level focuses on `( ... )`.

```bash
#!/usr/bin/env bash
set -euo pipefail

result=$(cd /; pwd)
echo "subshell_pwd=$result"
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
