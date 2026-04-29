# Guide for Check OS Type

Goal: Inspect `uname -s` and print exactly one of `Linux`, `macOS`, or `Other`.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: `uname` in condition.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

os=$(uname -s)

if [ "$os" = "Linux" ]; then
  echo "Linux"
elif [ "$os" = "Darwin" ]; then
  echo "macOS"
else
  echo "Other"
fi
```
