# Solution Guide: ShellCheck Clean Script

This level focuses on write shellcheck-clean code.

```bash
#!/usr/bin/env bash
set -euo pipefail

names=("alpha" "two words" "gamma")
for name in "${names[@]}"; do
  printf '[%s]\n' "$name"
done
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
