# Guide for Case Statement

Goal: Use a `case` statement on the first argument. Print `red=#ff0000`, `green=#00ff00`, `blue=#0000ff`, or `unknown`.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: `case $var in ... esac`.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  red) echo "red=#ff0000" ;;
  green) echo "green=#00ff00" ;;
  blue) echo "blue=#0000ff" ;;
  *) echo "unknown" ;;
esac
```
