# Solution Guide: Memoize a Function

This level focuses on cache results in assoc array.

```bash
#!/usr/bin/env bash
set -euo pipefail

declare -A cache
calls=0
square(){ local n=$1; if [[ ! -v cache[$n] ]]; then ((++calls)); cache[$n]=$((n*n)); fi; echo "${cache[$n]}"; }
square 4 >/dev/null
square 4 >/dev/null
echo "calls=$calls"
echo "value=${cache[4]}"
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
