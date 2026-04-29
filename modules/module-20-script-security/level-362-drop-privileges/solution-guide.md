# Solution Guide: Drop Privileges

This level focuses on run as target user safely.

```bash
#!/usr/bin/env bash
set -euo pipefail
target_user=${USER:-unknown}
echo "target=$target_user"
echo 'drop_privileges=simulated'
```

The script demonstrates the concept safely inside the mission workspace.
