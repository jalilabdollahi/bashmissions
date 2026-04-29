# Solution Guide: Middleware Chain

This level focuses on pipeline of functions.

```bash
#!/usr/bin/env bash
set -euo pipefail

trim(){ x=${1// /}; echo "$x"; }
wrap(){ echo "[$1]"; }
value=" a b "
value=$(trim "$value")
value=$(wrap "$value")
echo "$value"
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
