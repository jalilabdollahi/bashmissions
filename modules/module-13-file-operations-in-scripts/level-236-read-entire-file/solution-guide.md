# Solution Guide: Read Entire File

This level focuses on `$(<file)`.

```bash
#!/usr/bin/env bash
set -euo pipefail

content=$(< fixtures/data.txt)
printf '%s\n' "$content"
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
