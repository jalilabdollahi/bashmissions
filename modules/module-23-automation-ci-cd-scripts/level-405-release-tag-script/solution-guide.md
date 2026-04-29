# Solution Guide: Release Tag Script

This level focuses on git tag + push.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
tag=v1.2.3
OUT
cat result.txt
```

The script demonstrates the concept safely inside the mission workspace.
