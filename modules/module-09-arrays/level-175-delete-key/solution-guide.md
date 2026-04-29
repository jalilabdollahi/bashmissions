# Solution Guide: Delete Key

This level focuses on `unset map[key]`.

```bash
#!/usr/bin/env bash
set -euo pipefail

declare -A colors=([red]=1 [blue]=1)
unset 'colors[red]'
if [[ -v colors[red] ]]; then
  echo 'red=present'
else
  echo 'red=missing'
fi
echo "blue=${colors[blue]}"
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
