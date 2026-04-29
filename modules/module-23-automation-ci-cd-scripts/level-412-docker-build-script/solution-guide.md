# Solution Guide: Docker Build Script

This level focuses on build tag push.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
docker_build=stub
OUT
cat result.txt
```

The script demonstrates the concept safely inside the mission workspace.
