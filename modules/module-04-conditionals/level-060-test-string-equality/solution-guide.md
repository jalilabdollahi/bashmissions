# Guide for Test String Equality

Goal: Compare the first two arguments as strings with `[ "$a" = "$b" ]`. Print `same` when they match, otherwise `different`.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: `[ "$a" = "$b" ]`.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

a="$1"
b="$2"

if [ "$a" = "$b" ]; then
  echo "same"
else
  echo "different"
fi
```
