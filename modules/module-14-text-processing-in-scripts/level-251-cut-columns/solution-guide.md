# Solution Guide: Cut Columns

This level focuses on `cut -d, -f2`.

```bash
#!/usr/bin/env bash
set -euo pipefail

cut -d, -f2 fixtures/data.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
