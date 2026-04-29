# Solution Guide: Count Log Events

This level focuses on frequency table.

```bash
#!/usr/bin/env bash
set -euo pipefail
awk '{print $2}' fixtures/app.log | sort | uniq -c | awk '{print $2 "=" $1}' | sort
```

The script uses a small fixture so the data operation is visible and deterministic.
