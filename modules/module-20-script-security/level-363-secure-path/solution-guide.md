# Solution Guide: Secure PATH

This level focuses on reset PATH at script start.

```bash
#!/usr/bin/env bash
set -euo pipefail
PATH='/usr/local/bin:/usr/bin:/bin'
echo "path=$PATH"
```

The script demonstrates the concept safely inside the mission workspace.
