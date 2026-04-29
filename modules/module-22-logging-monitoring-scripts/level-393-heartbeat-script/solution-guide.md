# Solution Guide: Heartbeat Script

This level focuses on periodic ping/log.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
heartbeat=1
heartbeat=2
OUT
cat output.txt
```

The script demonstrates the concept safely inside the mission workspace.
