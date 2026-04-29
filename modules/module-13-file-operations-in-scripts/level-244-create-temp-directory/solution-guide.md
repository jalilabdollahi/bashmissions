# Solution Guide: Create Temp Directory

This level focuses on `mktemp -d`.

```bash
#!/usr/bin/env bash
set -euo pipefail

dir=$(mktemp -d)
echo "inside" > "$dir/item.txt"
echo "dir=$([[ -d $dir ]] && echo yes || echo no)"
echo "file=$(cat "$dir/item.txt")"
rm -rf "$dir"
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
