# Guide for File is Readable

Goal: Use `-r` to test whether the path in `$1` is readable. Print `readable` if it is readable, otherwise `not readable`.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: `-r`, `-w`, `-x`.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

if [ -r "$1" ]; then
  echo "readable"
else
  echo "not readable"
fi
```
