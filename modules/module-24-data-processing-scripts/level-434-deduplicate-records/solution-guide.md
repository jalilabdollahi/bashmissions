# Solution Guide: Deduplicate Records

This level focuses on sort -u on key.

```bash
#!/usr/bin/env bash
set -euo pipefail
sort -t, -k1,1 -u fixtures/data.csv
```

The script uses a small fixture so the data operation is visible and deterministic.
