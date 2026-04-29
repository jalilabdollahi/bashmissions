# Guide for Logical OR in Test

Goal: Use `||` inside `[[ ]]` to check whether either of the first two arguments is `yes`. Print `allowed` if either one is `yes`; otherwise print `denied`.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: `||` inside `[[ ]]`.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ ${1:-} == "yes" || ${2:-} == "yes" ]]; then
  echo "allowed"
else
  echo "denied"
fi
```
