# Solution Guide: Validate Required Config

This level focuses on check all required vars.

```bash
#!/usr/bin/env bash
set -euo pipefail

HOST=localhost
required=(HOST PORT)
missing=()
for key in "${required[@]}"; do [[ -v $key ]] || missing+=("$key"); done
if ((${#missing[@]})); then echo "missing=${missing[*]}"; else echo ok; fi
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
