# Solution Guide: Variadic Functions

This level focuses on `"$@"` forwarding.

```bash
#!/usr/bin/env bash
set -euo pipefail

join_args(){ printf '<%s>\n' "$@"; }
wrapper(){ join_args "$@"; }
wrapper alpha "two words"
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
