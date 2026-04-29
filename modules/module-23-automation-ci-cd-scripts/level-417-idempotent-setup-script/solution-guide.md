# Solution Guide: Idempotent Setup Script

This level focuses on check before create.

```bash
#!/usr/bin/env bash
set -euo pipefail
mkdir -p app
created=no
[[ -d app ]] && exists=yes
echo "created=$created"
echo "exists=$exists"
```

The script demonstrates the concept safely inside the mission workspace.
