# Solution Guide: Append to Array

This level focuses on `arr+=(new)`.

```bash
#!/usr/bin/env bash
set -euo pipefail

stages=(build test)
stages+=(production)
echo "${stages[*]}"
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
