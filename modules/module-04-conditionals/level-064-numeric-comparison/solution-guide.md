# Guide for Numeric Comparison

Goal: Compare the first two arguments as integers. Print `less`, `equal`, or `greater` using numeric test operators such as `-lt`, `-eq`, and `-gt`.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: `-eq -ne -lt -gt -le -ge`.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

if [ "$1" -lt "$2" ]; then
  echo "less"
elif [ "$1" -eq "$2" ]; then
  echo "equal"
else
  echo "greater"
fi
```
