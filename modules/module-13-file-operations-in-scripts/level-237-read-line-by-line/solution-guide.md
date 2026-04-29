# Solution Guide: Read Line by Line

This level focuses on `while IFS= read -r`.

```bash
#!/usr/bin/env bash
set -euo pipefail

n=1
while IFS= read -r line; do
  echo "$n:$line"
  ((n++))
done < fixtures/data.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
