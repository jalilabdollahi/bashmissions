# Solution Guide: Parse CSV File

This level focuses on IFS split per line.

```bash
#!/usr/bin/env bash
set -euo pipefail

first=1
while IFS=, read -r name role; do
  if (( first )); then
    first=0
    continue
  fi
  echo "$name=$role"
done < fixtures/data.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
