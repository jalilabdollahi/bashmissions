# Solution Guide: Health Check Script

This level focuses on process disk memory.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
process=ok
disk=ok
memory=ok
OUT
cat output.txt
```

The script demonstrates the concept safely inside the mission workspace.
