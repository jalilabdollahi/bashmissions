# Solution Guide: Delete Characters

This level focuses on `tr -d`.

```bash
#!/usr/bin/env bash
set -euo pipefail

tr -d '-' < fixtures/data.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
