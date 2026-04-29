# Solution Guide: Check Running as Root

This level focuses on guard non-root scripts.

```bash
#!/usr/bin/env bash
set -euo pipefail
if (( EUID == 0 )); then echo 'root=yes'; else echo 'root=no'; fi
```

The script demonstrates the concept safely inside the mission workspace.
