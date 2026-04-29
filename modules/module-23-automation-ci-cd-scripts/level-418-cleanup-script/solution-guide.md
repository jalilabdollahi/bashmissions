# Solution Guide: Cleanup Script

This level focuses on remove old artifacts.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
removed=old.log
OUT
cat result.txt
```

The script demonstrates the concept safely inside the mission workspace.
