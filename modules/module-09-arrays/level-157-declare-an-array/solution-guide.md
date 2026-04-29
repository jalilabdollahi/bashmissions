# Solution Guide: Declare an Array

This level focuses on `arr=(a b c)`.

```bash
#!/usr/bin/env bash
set -euo pipefail

arr=(alpha beta gamma)
echo "${arr[*]}"
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
