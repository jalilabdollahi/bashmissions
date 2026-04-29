# Solution Guide: Restrict Permissions

This level focuses on umask in scripts.

```bash
#!/usr/bin/env bash
set -euo pipefail
umask 077
: > secret.txt
echo "perm=$(stat -c '%a' secret.txt)"
```

The script demonstrates the concept safely inside the mission workspace.
