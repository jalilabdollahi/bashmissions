# Solution Guide: Atomic Write

This level focuses on write-then-move pattern.

```bash
#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp final.XXXXXX)
echo "version=2" > "$tmp"
mv "$tmp" config.txt
cat config.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
