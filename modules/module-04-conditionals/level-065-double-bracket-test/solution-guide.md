# Guide for Double Bracket Test

Goal: Use `[[ ... ]]` to test whether the first argument ends in `.txt`. Print `text file` for `.txt` names, otherwise `other`.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: `[[ ... ]]` advantages.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $1 == *.txt ]]; then
  echo "text file"
else
  echo "other"
fi
```
