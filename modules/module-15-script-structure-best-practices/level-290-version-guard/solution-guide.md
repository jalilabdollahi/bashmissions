# Solution Guide: Version Guard

This level focuses on check bash version.

```bash
#!/usr/bin/env bash
set -euo pipefail

if (( BASH_VERSINFO[0] >= 4 )); then
  printf 'bash_version=ok\n'
else
  printf 'bash_version=too_old\n'
  exit 1
fi
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
