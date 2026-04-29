# Solution Guide: set -o pipefail

This level focuses on catch pipe failures.

```bash
#!/usr/bin/env bash
set -u

if (set -o pipefail; false | true); then
  echo "pipeline=ok"
else
  echo "pipeline=failed"
fi
```

The script demonstrates the failure-handling pattern while keeping the checker output deterministic.
