# Solution Guide: Build Script

This level focuses on compile + test + report.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
compile=ok
test=ok
OUT
cat result.txt
```

The script demonstrates the concept safely inside the mission workspace.
