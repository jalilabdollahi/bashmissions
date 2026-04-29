# Solution Guide: Validate CSV Schema

This level focuses on check column count.

```bash
#!/usr/bin/env bash
set -euo pipefail
awk -F, 'NF != 3 {bad++} END {print bad ? "schema=bad" : "schema=ok"}' fixtures/data.csv
```

The script uses a small fixture so the data operation is visible and deterministic.
