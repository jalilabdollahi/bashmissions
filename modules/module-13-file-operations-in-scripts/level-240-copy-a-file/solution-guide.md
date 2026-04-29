# Solution Guide: Copy a File

This level focuses on `cp` with error check.

```bash
#!/usr/bin/env bash
set -euo pipefail

cp fixtures/data.txt copy.txt
if cmp -s fixtures/data.txt copy.txt; then
  echo "copy=ok"
fi
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
