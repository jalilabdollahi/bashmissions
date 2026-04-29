# Solution Guide: Transform CSV Columns

This level focuses on awk reorder.

```bash
#!/usr/bin/env bash
set -euo pipefail
awk -F, 'NR > 1 {print $2 "," $1}' fixtures/data.csv
```

The script uses a small fixture so the data operation is visible and deterministic.
