# Solution Guide: Usage Function

This level focuses on print_usage() with exit.

```bash
#!/usr/bin/env bash
set -euo pipefail

print_usage() {
  printf 'Usage: %s <file>\n' "${0##*/}"
}

if [[ ${1:-} == "--help" || $# -eq 0 ]]; then
  print_usage
  exit 0
fi
printf 'file=%s\n' "$1"
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
