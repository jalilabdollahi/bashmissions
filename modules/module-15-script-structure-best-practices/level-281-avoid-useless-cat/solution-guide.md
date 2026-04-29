# Solution Guide: Avoid Useless Cat

This level focuses on `< file` not `cat file |`.

```bash
#!/usr/bin/env bash
set -euo pipefail

lines=$(wc -l < fixtures/data.txt)
printf 'lines=%s\n' "$lines"
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
