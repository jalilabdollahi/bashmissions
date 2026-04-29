# Solution Guide: Squeeze Whitespace

This level focuses on `tr -s ' '`.

```bash
#!/usr/bin/env bash
set -euo pipefail

tr -s ' ' < fixtures/data.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
