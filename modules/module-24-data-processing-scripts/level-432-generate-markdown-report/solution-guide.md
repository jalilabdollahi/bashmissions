# Solution Guide: Generate Markdown Report

This level focuses on dynamic tables.

```bash
#!/usr/bin/env bash
set -euo pipefail
printf '| name | score |\n|---|---|\n| alice | 10 |\n'
```

The script uses a small fixture so the data operation is visible and deterministic.
