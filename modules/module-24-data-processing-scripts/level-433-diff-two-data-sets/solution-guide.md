# Solution Guide: Diff Two Data Sets

This level focuses on comm or diff.

```bash
#!/usr/bin/env bash
set -euo pipefail
comm -3 <(sort fixtures/a.txt) <(sort fixtures/b.txt) | sed 's/^\t/right=/; s/^/left=/'
```

The script uses a small fixture so the data operation is visible and deterministic.
