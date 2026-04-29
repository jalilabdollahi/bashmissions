# Solution Guide: DRY with Functions

This level focuses on no copy-pasted logic.

```bash
#!/usr/bin/env bash
set -euo pipefail

print_status() {
  local service=$1
  local state=$2
  printf '%s=%s\n' "$service" "$state"
}
print_status api ok
print_status worker ok
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
