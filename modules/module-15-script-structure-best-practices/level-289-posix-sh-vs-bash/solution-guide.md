# Solution Guide: POSIX sh vs bash

This level focuses on know when you need bash.

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ -n ${BASH_VERSION:-} ]]; then
  values=(alpha beta)
  printf 'bash=yes\n'
  printf 'array_second=%s\n' "${values[1]}"
fi
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
