# Solution Guide: Close File Descriptor

This level focuses on `exec 3>&-`.

```bash
#!/usr/bin/env bash
set -euo pipefail

exec 3> closed.log
echo "before close" >&3
exec 3>&-
if ! echo "after close" >&3 2> /dev/null; then
  echo "fd3=closed"
fi
cat closed.log
```

The key is to use the redirection or pipeline operator for the work, then print deterministic output for the mission checker.
