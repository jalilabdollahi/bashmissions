# Solution Guide: Merge Files by Key

This level focuses on multi-file join.

```bash
#!/usr/bin/env bash
set -euo pipefail
join -t, fixtures/a.csv fixtures/b.csv | join -t, - fixtures/c.csv
```

The script uses a small fixture so the data operation is visible and deterministic.
