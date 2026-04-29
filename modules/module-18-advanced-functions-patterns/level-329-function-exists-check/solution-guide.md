# Solution Guide: Function Exists Check

This level focuses on `declare -F func`.

```bash
#!/usr/bin/env bash
set -euo pipefail

build(){ :; }
if declare -F build >/dev/null; then echo "build=exists"; fi
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
