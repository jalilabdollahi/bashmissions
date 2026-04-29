# Guide for if-else

Goal: Use `if`/`else` to make a binary decision. Print `enabled` when the first argument is `on`; otherwise print `disabled`.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: binary decision.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

if [ "$1" = "on" ]; then
  echo "enabled"
else
  echo "disabled"
fi
```
