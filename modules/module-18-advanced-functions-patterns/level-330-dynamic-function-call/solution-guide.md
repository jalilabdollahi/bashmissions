# Solution Guide: Dynamic Function Call

This level focuses on `"$func" args`.

```bash
#!/usr/bin/env bash
set -euo pipefail

deploy(){ echo "deploy=$1"; }
func=deploy
"$func" api
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
