# Solution Guide: Transform JSON-like Text

This level focuses on extract values with grep/awk.

```bash
#!/usr/bin/env bash
set -euo pipefail

grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' fixtures/data.txt | awk -F'"' '{print "name=" $4}'
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
