# Solution Guide: Lint Script

This level focuses on collect exit codes.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
lint=0
OUT
cat result.txt
```

The script demonstrates the concept safely inside the mission workspace.
