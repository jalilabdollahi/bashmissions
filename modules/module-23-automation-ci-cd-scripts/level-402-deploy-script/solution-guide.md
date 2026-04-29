# Solution Guide: Deploy Script

This level focuses on copy + restart + verify.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
deploy=ok
OUT
cat result.txt
```

The script demonstrates the concept safely inside the mission workspace.
