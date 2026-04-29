# Solution Guide: Filter CSV Rows

This level focuses on awk condition.

```bash
#!/usr/bin/env bash
set -euo pipefail
awk -F, 'NR > 1 && $3 > 100 {print $1}' fixtures/data.csv
```

The script uses a small fixture so the data operation is visible and deterministic.
