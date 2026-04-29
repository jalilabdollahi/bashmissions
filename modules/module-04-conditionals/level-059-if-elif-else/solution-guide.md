# Guide for if-elif-else

Goal: Use `if`/`elif`/`else` for three branches. Print `starting` for `start`, `stopping` for `stop`, and `unknown` for anything else.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: multiple branches.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

if [ "$1" = "start" ]; then
  echo "starting"
elif [ "$1" = "stop" ]; then
  echo "stopping"
else
  echo "unknown"
fi
```
