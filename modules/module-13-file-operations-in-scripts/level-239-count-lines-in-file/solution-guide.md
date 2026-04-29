# Solution Guide: Count Lines in File

This level focuses on `wc -l`.

```bash
#!/usr/bin/env bash
set -euo pipefail

count=$(wc -l < fixtures/data.txt)
echo "lines=$count"
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
