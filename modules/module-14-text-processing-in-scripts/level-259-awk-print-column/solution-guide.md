# Solution Guide: awk Print Column

This level focuses on `awk '{print $2}'`.

```bash
#!/usr/bin/env bash
set -euo pipefail

awk '{print $2}' fixtures/data.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
