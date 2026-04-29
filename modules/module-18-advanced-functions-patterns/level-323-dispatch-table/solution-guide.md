# Solution Guide: Dispatch Table

This level focuses on assoc array of function names.

```bash
#!/usr/bin/env bash
set -euo pipefail

say_hello(){ echo "hello=$1"; }
declare -A dispatch=([hello]=say_hello)
cmd=${1:-hello}
"${dispatch[$cmd]}" bash
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
