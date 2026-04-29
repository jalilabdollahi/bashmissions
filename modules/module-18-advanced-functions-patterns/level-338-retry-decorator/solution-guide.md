# Solution Guide: Retry Decorator

This level focuses on wrap any command.

```bash
#!/usr/bin/env bash
set -euo pipefail

attempt=0
flaky(){ ((++attempt)); (( attempt >= 2 )); }
retry(){ until "$@"; do echo "retry=$attempt"; done; }
retry flaky
echo "success=$attempt"
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
