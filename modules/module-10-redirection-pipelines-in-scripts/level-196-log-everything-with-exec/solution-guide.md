# Solution Guide: Log Everything with exec

This level focuses on `exec > >(tee logfile)`.

```bash
#!/usr/bin/env bash
set -euo pipefail

exec 4>&1
exec > >(tee full.log)
echo "build started"
echo "build finished"
exec >&4
exec 4>&-
wait
echo "log:$(paste -sd, full.log)"
```

The key is to use the redirection or pipeline operator for the work, then print deterministic output for the mission checker.
