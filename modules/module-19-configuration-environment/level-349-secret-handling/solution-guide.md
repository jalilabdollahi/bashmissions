# Solution Guide: Secret Handling

This level focuses on never echo secrets.

```bash
#!/usr/bin/env bash
set -euo pipefail

API_TOKEN="supersecret"
if [[ -n $API_TOKEN ]]; then echo "token=loaded"; fi
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
