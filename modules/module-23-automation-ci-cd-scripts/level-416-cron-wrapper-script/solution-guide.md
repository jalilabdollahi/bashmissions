# Solution Guide: Cron Wrapper Script

This level focuses on lock log notify.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
cron=ran
OUT
cat result.txt
```

The script demonstrates the concept safely inside the mission workspace.
