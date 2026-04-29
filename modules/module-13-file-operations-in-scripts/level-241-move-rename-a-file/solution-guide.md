# Solution Guide: Move/Rename a File

This level focuses on `mv`.

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "renamed content" > original.txt
mv original.txt renamed.txt
cat renamed.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
