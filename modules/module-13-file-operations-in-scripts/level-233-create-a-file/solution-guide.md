# Solution Guide: Create a File

This level focuses on `touch`, `>`.

```bash
#!/usr/bin/env bash
set -euo pipefail

touch created.txt
echo "exists=$([[ -f created.txt ]] && echo yes || echo no)"
echo "bytes=$(wc -c < created.txt)"
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
