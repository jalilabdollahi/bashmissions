# Solution Guide: Array from File Lines

This level focuses on mapfile.

```bash
#!/usr/bin/env bash
set -euo pipefail

file=${1:?provide a file path}
mapfile -t lines < "$file"
last_index=$((${#lines[@]} - 1))
echo "count=${#lines[@]}"
echo "first=${lines[0]}"
echo "last=${lines[$last_index]}"
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
