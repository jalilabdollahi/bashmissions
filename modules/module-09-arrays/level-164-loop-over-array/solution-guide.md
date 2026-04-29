# Solution Guide: Loop over Array

This level focuses on `for item in "${arr[@]}"`.

```bash
#!/usr/bin/env bash
set -euo pipefail

steps=(build test deploy)
for step in "${steps[@]}"; do
  echo "step=$step"
done
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
