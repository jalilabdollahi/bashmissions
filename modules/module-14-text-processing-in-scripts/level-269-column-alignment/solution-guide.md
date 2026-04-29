# Solution Guide: Column Alignment

This level focuses on `column -t`.

```bash
#!/usr/bin/env bash
set -euo pipefail

column -t -s, fixtures/data.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
