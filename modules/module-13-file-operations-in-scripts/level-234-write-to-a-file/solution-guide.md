# Solution Guide: Write to a File

This level focuses on echo redirect.

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "status=ready" > status.txt
cat status.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
