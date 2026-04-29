# Solution Guide: Config File with Defaults

This level focuses on layered config merging.

```bash
#!/usr/bin/env bash
set -euo pipefail

host=localhost
port=3000
source fixtures/app.conf
echo "host=$host"
echo "port=$port"
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
