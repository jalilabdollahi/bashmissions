# Solution Guide: Redirect stderr to stdout

This level focuses on `2>&1`.

```bash
#!/usr/bin/env bash
set -euo pipefail

{ echo "error: missing config" >&2; } 2>&1 | sed 's/^/captured: /'
```

The key is to use the redirection or pipeline operator for the work, then print deterministic output for the mission checker.
