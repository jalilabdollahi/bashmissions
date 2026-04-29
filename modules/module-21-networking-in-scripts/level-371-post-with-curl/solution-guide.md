# Solution Guide: POST with curl

This level focuses on `curl -X POST -d data`.

```bash
#!/usr/bin/env bash
set -euo pipefail
method=POST
payload='name=ada'
printf 'method=%s\n' "$method"
printf 'payload=%s\n' "$payload"
```

The script demonstrates the concept safely inside the mission workspace.
