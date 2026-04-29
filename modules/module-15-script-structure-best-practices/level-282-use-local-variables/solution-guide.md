# Solution Guide: Use Local Variables

This level focuses on prevent global leaks.

```bash
#!/usr/bin/env bash
set -euo pipefail

status="global"
set_status() {
  local status="local"
  printf 'inside=%s\n' "$status"
}
set_status
printf 'outside=%s\n' "$status"
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
