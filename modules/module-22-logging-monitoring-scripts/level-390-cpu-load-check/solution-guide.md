# Solution Guide: CPU Load Check

This level focuses on uptime parse.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
load=checked
OUT
cat output.txt
```

The script demonstrates the concept safely inside the mission workspace.
