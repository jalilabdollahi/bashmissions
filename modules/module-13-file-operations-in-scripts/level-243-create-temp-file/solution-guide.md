# Solution Guide: Create Temp File

This level focuses on `mktemp`.

```bash
#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp)
echo "temp data" > "$tmp"
cat "$tmp"
rm -f "$tmp"
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
