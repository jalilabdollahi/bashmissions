# Solution Guide: Redirect stdout to File

This level focuses on `>` and `>>`.

```bash
#!/usr/bin/env bash
set -euo pipefail

log=stdout.log
echo "first" > "$log"
echo "second" >> "$log"
cat "$log"
```

The key is to use the redirection or pipeline operator for the work, then print deterministic output for the mission checker.
