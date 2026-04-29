# Solution Guide: Append to a File

This level focuses on `>>`.

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "first" > log.txt
echo "second" >> log.txt
cat log.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
