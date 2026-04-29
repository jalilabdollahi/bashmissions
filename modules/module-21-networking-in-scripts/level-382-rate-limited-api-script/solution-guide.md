# Solution Guide: Rate-Limited API Script

This level focuses on sleep between calls.

```bash
#!/usr/bin/env bash
set -euo pipefail
for id in 1 2 3; do echo "request=$id"; sleep 0.01; done
```

The script demonstrates the concept safely inside the mission workspace.
