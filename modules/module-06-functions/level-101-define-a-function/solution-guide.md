# Guide for Define a Function

Goal: Define a function named `greet` that prints `hello from function`, then call it once.

Work in this order:

1. Define the function needed for the level.
2. Use the function pattern from this concept: `function_name() { }`.
3. Call the function with quoted arguments when values may contain spaces.
4. Match stdout and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

greet() {
  echo "hello from function"
}

greet
```
