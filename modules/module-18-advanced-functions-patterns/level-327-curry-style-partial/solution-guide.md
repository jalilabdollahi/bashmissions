# Solution Guide: Curry-Style Partial

This level focuses on factory functions.

```bash
#!/usr/bin/env bash
set -euo pipefail

make_logger(){ local name=$1 prefix=$2; eval "$name(){ printf '%s=%s\\n' '$prefix' \"\$1\"; }"; }
make_logger log_api api
log_api ready
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
