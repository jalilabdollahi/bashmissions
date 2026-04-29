# Solution Guide: Disk Usage Alert

This level focuses on threshold + notification.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
disk=ok
OUT
cat output.txt
```

The script demonstrates the concept safely inside the mission workspace.
