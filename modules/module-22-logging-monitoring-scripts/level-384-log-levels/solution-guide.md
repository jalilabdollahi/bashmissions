# Solution Guide: Log Levels

This level focuses on DEBUG INFO WARN ERROR.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
INFO ready
WARN disk
OUT
cat output.txt
```

The script demonstrates the concept safely inside the mission workspace.
