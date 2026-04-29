# Solution Guide: Rollback Script

This level focuses on restore previous version.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
version=previous
OUT
cat result.txt
```

The script demonstrates the concept safely inside the mission workspace.
