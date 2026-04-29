# Solution Guide: Count Occurrences

This level focuses on `sort | uniq -c | sort -rn`.

```bash
#!/usr/bin/env bash
set -euo pipefail

sort fixtures/data.txt | uniq -c | sort -rn | awk '{print $2 "=" $1}'
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
