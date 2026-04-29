# Solution Guide: Secret Injection Script

This level focuses on render template.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
token=[set]
OUT
cat result.txt
```

The script demonstrates the concept safely inside the mission workspace.
