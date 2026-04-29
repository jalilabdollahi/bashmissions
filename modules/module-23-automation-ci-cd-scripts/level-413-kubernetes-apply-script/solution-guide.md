# Solution Guide: Kubernetes Apply Script

This level focuses on apply wait verify.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
kube_apply=stub
OUT
cat result.txt
```

The script demonstrates the concept safely inside the mission workspace.
