# Solution Guide: Modular Script Layout

This level focuses on organize into sections.

```bash
#!/usr/bin/env bash
set -euo pipefail

APP_NAME="bashmissions"

format_name() {
  printf '%s:%s\n' "$APP_NAME" "$1"
}

main() {
  format_name "module-layout"
}

main "$@"
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
