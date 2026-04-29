# Solution Guide: Timestamped Log

This level focuses on timestamped printf.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
[2026-04-29] deploy
OUT
cat output.txt
```

The script demonstrates the concept safely inside the mission workspace.
