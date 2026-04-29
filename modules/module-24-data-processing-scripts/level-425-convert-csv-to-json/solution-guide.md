# Solution Guide: Convert CSV to JSON

This level focuses on awk JSON output.

```bash
#!/usr/bin/env bash
set -euo pipefail
awk -F, 'NR==2{printf "{\"name\":\"%s\",\"score\":%s}\n",$1,$2}' fixtures/data.csv
```

The script uses a small fixture so the data operation is visible and deterministic.
