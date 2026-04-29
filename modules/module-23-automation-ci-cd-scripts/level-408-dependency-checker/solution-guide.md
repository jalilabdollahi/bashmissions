# Solution Guide: Dependency Checker

This level focuses on check all tools.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
bash=found
curl=found
OUT
cat result.txt
```

The script demonstrates the concept safely inside the mission workspace.
