# Solution Guide: Dry-Run Mode

This level focuses on `DRY_RUN=1` flag.

```bash
#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=${DRY_RUN:-1}
run_cmd() {
  if [[ $DRY_RUN == 1 ]]; then
    printf 'DRY: %s\n' "$*"
  else
    "$@"
  fi
}
run_cmd rm output.txt
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
