# Guide for Check Command Exists

Goal: Use `command -v` to check whether the command named in `$1` exists. Print `found` if it does, otherwise `missing`.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: `command -v`.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

if command -v "$1" >/dev/null 2>&1; then
  echo "found"
else
  echo "missing"
fi
```
