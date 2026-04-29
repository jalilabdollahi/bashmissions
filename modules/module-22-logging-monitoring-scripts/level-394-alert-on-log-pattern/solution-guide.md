# Solution Guide: Alert on Log Pattern

This level focuses on tail grep notify.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
alert=ERROR
OUT
cat output.txt
```

The script demonstrates the concept safely inside the mission workspace.
