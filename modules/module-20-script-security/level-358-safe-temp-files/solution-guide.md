# Solution Guide: Safe Temp Files

This level focuses on mktemp, not predictable names.

```bash
#!/usr/bin/env bash
set -euo pipefail
tmp=$(mktemp)
echo data > "$tmp"
echo "created=$([[ -f $tmp ]] && echo yes || echo no)"
rm -f "$tmp"
```

The script demonstrates the concept safely inside the mission workspace.
