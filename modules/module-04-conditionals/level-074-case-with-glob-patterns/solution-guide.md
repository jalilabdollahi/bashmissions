# Guide for Case with Glob Patterns

Goal: Use `case` glob patterns to classify the first argument. Print `shell` for `*.sh`, `text` for `*.txt`, and `other` for everything else.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: `case` pattern matching.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  *.sh) echo "shell" ;;
  *.txt) echo "text" ;;
  *) echo "other" ;;
esac
```
