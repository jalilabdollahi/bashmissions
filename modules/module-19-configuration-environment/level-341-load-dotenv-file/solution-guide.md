# Solution Guide: Load dotenv File

This level focuses on parse `KEY=VALUE` into env.

```bash
#!/usr/bin/env bash
set -euo pipefail

set -a
source fixtures/app.env
set +a
echo "host=$HOST"
echo "port=$PORT"
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
