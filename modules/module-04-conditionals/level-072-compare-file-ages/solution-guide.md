# Guide for Compare File Ages

Goal: Create two temporary files, make the second one newer, and compare them with `-nt`. Print exactly `second newer`.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: `-nt`, `-ot`.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

first=$(mktemp)
second=$(mktemp)
trap 'rm -f "$first" "$second"' EXIT

touch -t 202001010000 "$first"
touch -t 202001010001 "$second"

if [ "$second" -nt "$first" ]; then
  echo "second newer"
fi
```
