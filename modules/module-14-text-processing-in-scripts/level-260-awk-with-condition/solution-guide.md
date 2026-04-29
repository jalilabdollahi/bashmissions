# Solution Guide: awk with Condition

This level focuses on `awk '$3 > 100'`.

```bash
#!/usr/bin/env bash
set -euo pipefail

awk '$3 > 100 {print $1}' fixtures/data.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
