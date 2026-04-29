# Solution Guide: Translate Characters

This level focuses on `tr`.

```bash
#!/usr/bin/env bash
set -euo pipefail

tr '[:lower:]' '[:upper:]' < fixtures/data.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
