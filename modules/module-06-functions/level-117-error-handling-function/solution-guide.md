# Guide for Error-Handling Function

Goal: Define a `die` function that prints `error: missing value` to stderr and exits 1 when no argument is provided. With an argument, print `value=<arg>`.

Work in this order:

1. Define the function needed for the level.
2. Use the function pattern from this concept: die() pattern.
3. Call the function with quoted arguments when values may contain spaces.
4. Match stdout and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

die() {
  echo "error: $1" >&2
  exit 1
}

if [ -z "${1:-}" ]; then
  die "missing value"
fi

echo "value=$1"
```
