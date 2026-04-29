# Solution Guide: Config Schema Check

This level focuses on validate types, ranges.

```bash
#!/usr/bin/env bash
set -euo pipefail

port=8080
if [[ $port =~ ^[0-9]+$ ]] && (( port >= 1 && port <= 65535 )); then echo "port=valid"; else echo "port=invalid"; fi
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
