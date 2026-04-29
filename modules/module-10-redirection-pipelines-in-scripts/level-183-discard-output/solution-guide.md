# Solution Guide: Discard Output

This level focuses on `>/dev/null`.

```bash
#!/usr/bin/env bash
set -euo pipefail

printf 'hidden output\n' > /dev/null
echo "visible output"
```

The key is to use the redirection or pipeline operator for the work, then print deterministic output for the mission checker.
