# Solution Guide: Prevent TOCTOU

This level focuses on atomic operations.

```bash
#!/usr/bin/env bash
set -euo pipefail
tmp=$(mktemp final.XXXXXX)
echo ready > "$tmp"
mv "$tmp" final.txt
cat final.txt
```

The script demonstrates the concept safely inside the mission workspace.
