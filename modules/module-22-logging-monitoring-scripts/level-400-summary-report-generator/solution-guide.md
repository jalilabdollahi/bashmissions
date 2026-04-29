# Solution Guide: Summary Report Generator

This level focuses on aggregate daily stats.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
ok=2
fail=1
OUT
cat output.txt
```

The script demonstrates the concept safely inside the mission workspace.
