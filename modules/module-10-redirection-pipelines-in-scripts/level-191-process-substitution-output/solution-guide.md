# Solution Guide: Process Substitution Output

This level focuses on `cmd >(other_cmd)`.

```bash
#!/usr/bin/env bash
set -euo pipefail

printf '%s\n' alpha beta > >(tr '[:lower:]' '[:upper:]' > uppercase.txt)
wait
cat uppercase.txt
```

The key is to use the redirection or pipeline operator for the work, then print deterministic output for the mission checker.
