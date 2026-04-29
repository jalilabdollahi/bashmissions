# Solution Guide: Retry HTTP Request

This level focuses on loop with backoff.

```bash
#!/usr/bin/env bash
set -euo pipefail
attempt=0
while true; do ((++attempt)); if (( attempt == 3 )); then echo "success_on=$attempt"; break; fi; echo "retry=$attempt"; done
```

The script demonstrates the concept safely inside the mission workspace.
