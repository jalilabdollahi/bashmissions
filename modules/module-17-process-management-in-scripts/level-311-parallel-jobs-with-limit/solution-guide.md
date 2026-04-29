# Solution Guide: Parallel Jobs with Limit

This level focuses on N workers pattern.

```bash
#!/usr/bin/env bash
set -euo pipefail

running=0
for item in a b c; do
  { echo "$item" > "$item.out"; } &
  ((++running))
  if (( running == 2 )); then
    wait -n
    ((--running))
  fi
done
wait
cat ./*.out | sort
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
