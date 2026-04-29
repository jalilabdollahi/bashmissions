# Guide for Return a String

Goal: Create a function that prints a string, capture it with command substitution, and print `value=<captured>`.

Work in this order:

1. Define the function needed for the level.
2. Use the function pattern from this concept: via echo + $().
3. Call the function with quoted arguments when values may contain spaces.
4. Match stdout and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

make_value() {
  echo "generated"
}

value=$(make_value)
echo "value=$value"
```
