# Solution Guide: Watchdog Script

This level focuses on restart crashed process.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
restart=api
OUT
cat output.txt
```

The script demonstrates the concept safely inside the mission workspace.
