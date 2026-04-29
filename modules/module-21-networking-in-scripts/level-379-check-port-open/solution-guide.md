# Solution Guide: Check Port Open

This level focuses on `nc -z host port`.

```bash
#!/usr/bin/env bash
set -euo pipefail
command -v nc >/dev/null && echo 'port_check=ready'
```

The script demonstrates the concept safely inside the mission workspace.
