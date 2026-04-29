# Guide for File Exists

Goal: Inspect the path in `$1`. Print `file` if it is a regular file, `directory` if it is a directory, and `missing` if it does not exist.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: `-e`, `-f`, `-d`.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

path="$1"

if [ -f "$path" ]; then
  echo "file"
elif [ -d "$path" ]; then
  echo "directory"
else
  echo "missing"
fi
```
