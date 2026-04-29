# Solution Guide: Environment Promo Script

This level focuses on promote config.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
promoted=staging
OUT
cat result.txt
```

The script demonstrates the concept safely inside the mission workspace.
