# Solution Guide: Unique Lines

This level focuses on `sort | uniq`.

```bash
#!/usr/bin/env bash
set -euo pipefail

sort fixtures/data.txt | uniq
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
