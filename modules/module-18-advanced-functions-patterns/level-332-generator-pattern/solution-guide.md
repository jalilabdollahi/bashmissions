# Solution Guide: Generator Pattern

This level focuses on function + global state.

```bash
#!/usr/bin/env bash
set -euo pipefail

counter=0
next_id(){ ((++counter)); }
next_id
echo "id=$counter"
next_id
echo "id=$counter"
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
