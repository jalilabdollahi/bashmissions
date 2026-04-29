# Solution Guide: Top N from Log

This level focuses on sort + head.

```bash
#!/usr/bin/env bash
set -euo pipefail
sort -nr fixtures/counts.txt | head -2
```

The script uses a small fixture so the data operation is visible and deterministic.
