# Solution Guide: Builder Pattern

This level focuses on chained config calls.

```bash
#!/usr/bin/env bash
set -euo pipefail

declare -A config
set_host(){ config[host]=$1; }
set_port(){ config[port]=$1; }
set_host localhost
set_port 8080
echo "host=${config[host]}"
echo "port=${config[port]}"
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
