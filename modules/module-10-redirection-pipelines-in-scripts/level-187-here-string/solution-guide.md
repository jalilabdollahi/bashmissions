# Solution Guide: Here-String

This level focuses on `cmd <<< "string"`.

```bash
#!/usr/bin/env bash
set -euo pipefail

tr '[:lower:]' '[:upper:]' <<< "hello from bash"
```

The key is to use the redirection or pipeline operator for the work, then print deterministic output for the mission checker.
