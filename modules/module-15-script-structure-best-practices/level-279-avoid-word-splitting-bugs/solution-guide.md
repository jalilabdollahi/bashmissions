# Solution Guide: Avoid Word Splitting Bugs

This level focuses on `"$@"` not `$@`.

```bash
#!/usr/bin/env bash
set -euo pipefail

for arg in "$@"; do
  printf '<%s>\n' "$arg"
done
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
