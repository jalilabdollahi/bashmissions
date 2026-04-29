# Solution Guide: Config Migration

This level focuses on upgrade old format.

```bash
#!/usr/bin/env bash
set -euo pipefail

cp fixtures/old.conf app.conf
sed -i 's/^url=/endpoint=/' app.conf
cat app.conf
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
