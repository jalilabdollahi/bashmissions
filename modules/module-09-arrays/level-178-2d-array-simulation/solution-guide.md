# Solution Guide: 2D Array Simulation

This level focuses on key encoding trick.

```bash
#!/usr/bin/env bash
set -euo pipefail

declare -A grid
grid[0,0]=A
grid[0,1]=B
grid[1,0]=C
grid[1,1]=D

echo "${grid[0,0]}${grid[0,1]}"
echo "${grid[1,0]}${grid[1,1]}"
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
