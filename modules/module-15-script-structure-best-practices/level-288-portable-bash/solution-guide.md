# Solution Guide: Portable Bash

This level focuses on avoid bashisms where possible.

```bash
#!/usr/bin/env bash
set -euo pipefail

file="fixtures/data.txt"
if [ -r "$file" ]; then
  printf 'portable=readable\n'
fi
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
