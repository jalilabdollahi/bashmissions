# Guide for Test String Inequality

Goal: Compare the first two arguments as strings with `!=`. Print `different` when they do not match, otherwise `same`.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: `!=`.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

if [ "$1" != "$2" ]; then
  echo "different"
else
  echo "same"
fi
```
