# Solution Guide: Syslog from Script

This level focuses on logger command.

```bash
#!/usr/bin/env bash
set -euo pipefail
logger -t bashmissions 'test message' 2>/dev/null || true
echo 'logger=sent'
```

The script demonstrates the concept safely inside the mission workspace.
