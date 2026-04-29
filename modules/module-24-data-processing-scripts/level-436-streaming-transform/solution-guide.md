# Solution Guide: Streaming Transform

This level focuses on process line by line, no temp file.

```bash
#!/usr/bin/env bash
set -euo pipefail
while IFS= read -r line; do echo "item=${line^^}"; done < fixtures/data.txt
```

The script uses a small fixture so the data operation is visible and deterministic.
