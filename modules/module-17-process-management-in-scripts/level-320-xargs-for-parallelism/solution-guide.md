# Solution Guide: xargs for Parallelism

This level focuses on `xargs -P N`.

```bash
#!/usr/bin/env bash
set -euo pipefail

printf '%s\n' a b c | xargs -n1 -P2 -I{} bash -c 'echo item=$1' _ {} | sort
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
