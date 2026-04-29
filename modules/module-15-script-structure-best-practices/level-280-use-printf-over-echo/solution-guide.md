# Solution Guide: Use Printf over Echo

This level focuses on portable output.

```bash
#!/usr/bin/env bash
set -euo pipefail

name=${1:-bash}
printf 'hello=%s\n' "$name"
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
