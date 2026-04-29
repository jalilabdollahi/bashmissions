# Solution Guide: Custom File Descriptor

This level focuses on `exec 3>file`.

```bash
#!/usr/bin/env bash
set -euo pipefail

exec 3> fd.log
echo "alpha" >&3
echo "beta" >&3
exec 3>&-
cat fd.log
```

The key is to use the redirection or pipeline operator for the work, then print deterministic output for the mission checker.
