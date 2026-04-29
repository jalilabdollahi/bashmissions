# Solution Guide: Event Emitter

This level focuses on signal-driven pattern.

```bash
#!/usr/bin/env bash
set -euo pipefail

on_ready(){ echo "ready=$1"; }
declare -a ready_handlers=(on_ready)
emit(){ local event=$1; shift; local -n handlers="${event}_handlers"; for h in "${handlers[@]}"; do "$h" "$@"; done; }
emit ready api
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
