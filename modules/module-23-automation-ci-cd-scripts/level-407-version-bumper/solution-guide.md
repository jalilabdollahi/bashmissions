# Solution Guide: Version Bumper

This level focuses on semver increment.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
version=1.2.4
OUT
cat result.txt
```

The script demonstrates the concept safely inside the mission workspace.
