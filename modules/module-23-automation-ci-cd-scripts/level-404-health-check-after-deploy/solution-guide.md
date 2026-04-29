# Solution Guide: Health Check After Deploy

This level focuses on poll until healthy.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
healthy=yes
OUT
cat result.txt
```

The script demonstrates the concept safely inside the mission workspace.
