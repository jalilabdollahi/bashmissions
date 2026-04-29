# Solution Guide: Metrics Collector

This level focuses on stats to file.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > output.txt <<'OUT'
cpu=1
mem=2
OUT
cat output.txt
```

The script demonstrates the concept safely inside the mission workspace.
