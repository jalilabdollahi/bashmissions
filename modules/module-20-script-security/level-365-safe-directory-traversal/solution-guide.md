# Solution Guide: Safe Directory Traversal

This level focuses on check symlinks.

```bash
#!/usr/bin/env bash
set -euo pipefail
mkdir -p tree
echo ok > tree/real.txt
ln -s real.txt tree/link.txt
for file in tree/*; do
  if [[ -L $file ]]; then
    echo "skip=$(basename "$file")"
  fi
done
```

The script demonstrates the concept safely inside the mission workspace.
