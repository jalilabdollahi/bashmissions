# Solution Guide: Strict Mode Setup

This level focuses on `set -euo pipefail` + IFS.

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

items=$'alpha\nbeta gamma'
count=0
for item in $items; do
  ((++count))
done
echo "strict=on"
echo "items=$count"
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
