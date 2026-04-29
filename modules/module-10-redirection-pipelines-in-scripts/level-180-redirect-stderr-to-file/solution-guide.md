# Solution Guide: Redirect stderr to File

This level focuses on `2>`.

```bash
#!/usr/bin/env bash
set -euo pipefail

log=stderr.log
{ echo "warning: disk low" >&2; } 2> "$log"
cat "$log"
```

The key is to use the redirection or pipeline operator for the work, then print deterministic output for the mission checker.
