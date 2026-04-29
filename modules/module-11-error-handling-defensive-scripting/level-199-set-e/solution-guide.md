# Solution Guide: set -e

This level focuses on abort on error.

```bash
#!/usr/bin/env bash
set -u

set +e
(set -e; echo before; false; echo after)
code=$?
set -e
if (( code != 0 )); then
  echo "aborted=true"
fi
```

The script demonstrates the failure-handling pattern while keeping the checker output deterministic.
