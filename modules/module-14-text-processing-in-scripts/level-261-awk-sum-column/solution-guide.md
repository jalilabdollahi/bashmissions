# Solution Guide: awk Sum Column

This level focuses on `awk '{sum+=$1} END{print sum}'`.

```bash
#!/usr/bin/env bash
set -euo pipefail

awk '{sum += $1} END {print sum}' fixtures/data.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
