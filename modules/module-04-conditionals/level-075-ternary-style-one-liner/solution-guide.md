# Guide for Ternary-Style One-Liner

Goal: Use a conditional one-liner with `[[ ... ]] && ... || ...`. Print `pass` when the first argument is `ok`; otherwise print `fail`.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: `[[ cond ]] && true || false`.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

[[ ${1:-} == "ok" ]] && echo "pass" || echo "fail"
```
