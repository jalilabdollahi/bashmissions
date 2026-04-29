# Solution Guide: Parse Log File

This level focuses on extract fields by regex.

```bash
#!/usr/bin/env bash
set -euo pipefail
sed -n 's/^\[.*\] ERROR \(.*\)$/error=\1/p' fixtures/app.log
```

The script uses a small fixture so the data operation is visible and deterministic.
