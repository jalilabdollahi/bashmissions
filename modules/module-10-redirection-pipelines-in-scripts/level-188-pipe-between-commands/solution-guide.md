# Solution Guide: Pipe Between Commands

This level focuses on `cmd1 | cmd2`.

```bash
#!/usr/bin/env bash
set -euo pipefail

count=$(printf '%s\n' alpha beta beta gamma | grep -c 'beta')
echo "beta_count=$count"
```

The key is to use the redirection or pipeline operator for the work, then print deterministic output for the mission checker.
