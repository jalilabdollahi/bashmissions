# Solution Guide: Handle SIGHUP

This level focuses on daemon-style script.

```bash
#!/usr/bin/env bash
set -euo pipefail

trap 'echo "reload=handled"' HUP
kill -HUP $$
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
