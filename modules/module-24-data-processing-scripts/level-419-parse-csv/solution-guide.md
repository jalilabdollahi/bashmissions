# Solution Guide: Parse CSV

This level focuses on IFS + while read.

```bash
#!/usr/bin/env bash
set -euo pipefail
while IFS=, read -r name score; do
  [[ $name == name ]] && continue
  echo "$name=$score"
done < fixtures/data.csv
```

The script uses a small fixture so the data operation is visible and deterministic.
