# Solution Guide: GNU Parallel Basics

This level focuses on `parallel` tool.

```bash
#!/usr/bin/env bash
set -euo pipefail

if command -v parallel >/dev/null 2>&1; then
  printf '%s\n' a b | parallel 'echo item={}' | sort
else
  printf '%s\n' a b | xargs -n1 -I{} echo item={} | sort
fi
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
