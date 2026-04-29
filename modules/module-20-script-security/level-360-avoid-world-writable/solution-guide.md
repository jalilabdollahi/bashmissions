# Solution Guide: Avoid World-Writable

This level focuses on chmod after create.

```bash
#!/usr/bin/env bash
set -euo pipefail
: > report.txt
chmod 600 report.txt
echo "perm=$(stat -c '%a' report.txt)"
```

The script demonstrates the concept safely inside the mission workspace.
