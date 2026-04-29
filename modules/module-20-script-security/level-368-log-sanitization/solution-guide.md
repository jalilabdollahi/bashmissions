# Solution Guide: Log Sanitization

This level focuses on remove secrets from logs.

```bash
#!/usr/bin/env bash
set -euo pipefail
secret='abc123'
line='login token=abc123 user=ada'
echo "${line//$secret/[REDACTED]}"
```

The script demonstrates the concept safely inside the mission workspace.
