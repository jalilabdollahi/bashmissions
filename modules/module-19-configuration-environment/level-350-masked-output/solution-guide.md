# Solution Guide: Masked Output

This level focuses on replace secret in logs.

```bash
#!/usr/bin/env bash
set -euo pipefail

secret="abc123"
log="token=abc123 status=ok"
echo "${log//$secret/******}"
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
