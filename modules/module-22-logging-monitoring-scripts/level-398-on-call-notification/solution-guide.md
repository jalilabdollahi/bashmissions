# Solution Guide: On-Call Notification

This level focuses on webhook alert.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
notify=queued
OUT
cat output.txt
```

The script demonstrates the concept safely inside the mission workspace.
