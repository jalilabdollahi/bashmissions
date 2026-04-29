# Solution Guide: Parse JSON Response

This level focuses on `jq` in scripts.

```bash
#!/usr/bin/env bash
set -euo pipefail
echo '{"status":"ok","count":2}' > response.json
jq -r '.status' response.json
```

The script demonstrates the concept safely inside the mission workspace.
