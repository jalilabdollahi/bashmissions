# Solution Guide: Audit Decorator

This level focuses on log all calls.

```bash
#!/usr/bin/env bash
set -euo pipefail

deploy(){ echo "deploy=$1"; }
audit(){ local func=$1; shift; echo "$func $*" >> audit.log; "$func" "$@"; }
audit deploy api
cat audit.log
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
