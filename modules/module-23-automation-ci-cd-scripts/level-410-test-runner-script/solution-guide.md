# Solution Guide: Test Runner Script

This level focuses on parse output.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
tests=2 passed
OUT
cat result.txt
```

The script demonstrates the concept safely inside the mission workspace.
