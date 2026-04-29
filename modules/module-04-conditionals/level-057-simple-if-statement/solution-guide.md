# Guide for Simple if Statement

Goal: Use a simple `if [ condition ]; then` statement. If the first argument is `yes`, print `matched`; otherwise print nothing and exit 0.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: `if [ condition ]; then`.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

if [ "$1" = "yes" ]; then
  echo "matched"
fi
```
