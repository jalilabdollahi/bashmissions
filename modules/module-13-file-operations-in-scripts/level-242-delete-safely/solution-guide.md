# Solution Guide: Delete Safely

This level focuses on check before delete.

```bash
#!/usr/bin/env bash
set -euo pipefail

target="scratch.tmp"
echo "temporary" > "$target"
if [[ -f $target && $target == *.tmp ]]; then
  rm -- "$target"
fi
echo "deleted=$([[ ! -e $target ]] && echo yes || echo no)"
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
