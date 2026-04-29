# Solution Guide: Wait All Backgrounds

This level focuses on `wait`.

```bash
#!/usr/bin/env bash
set -euo pipefail

{ sleep 0.05; echo one > one.txt; } &
{ sleep 0.05; echo two > two.txt; } &
wait
cat one.txt two.txt | sort
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
