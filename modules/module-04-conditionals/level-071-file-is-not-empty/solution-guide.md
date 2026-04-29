# Guide for File is Not Empty

Goal: Use `-s` to test whether the path in `$1` exists and has a size greater than zero. Print `not empty` or `empty`.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: `-s`.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

if [ -s "$1" ]; then
  echo "not empty"
else
  echo "empty"
fi
```
