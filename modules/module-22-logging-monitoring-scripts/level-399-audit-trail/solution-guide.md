# Solution Guide: Audit Trail

This level focuses on append action.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
deploy:ok
OUT
cat output.txt
```

The script demonstrates the concept safely inside the mission workspace.
