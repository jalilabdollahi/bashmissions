# Solution Guide: awk Field Separator

This level focuses on `awk -F,`.

```bash
#!/usr/bin/env bash
set -euo pipefail

awk -F, 'NR > 1 {print $1 ":" $3}' fixtures/data.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
