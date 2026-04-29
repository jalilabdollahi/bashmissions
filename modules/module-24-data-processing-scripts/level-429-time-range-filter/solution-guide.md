# Solution Guide: Time-Range Filter

This level focuses on compare timestamps.

```bash
#!/usr/bin/env bash
set -euo pipefail
awk '$1 >= "10:00" && $1 <= "10:30" {print $2}' fixtures/events.log
```

The script uses a small fixture so the data operation is visible and deterministic.
