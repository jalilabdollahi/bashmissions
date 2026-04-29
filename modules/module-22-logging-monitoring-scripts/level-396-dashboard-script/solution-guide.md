# Solution Guide: Dashboard Script

This level focuses on terminal status display.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
SERVICE STATUS
api ok
OUT
cat output.txt
```

The script demonstrates the concept safely inside the mission workspace.
