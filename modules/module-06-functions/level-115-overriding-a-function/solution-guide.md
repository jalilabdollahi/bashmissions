# Guide for Overriding a Function

Goal: Define a function named `message`, call it, redefine it, then call it again. Print `old` then `new`.

Work in this order:

1. Define the function needed for the level.
2. Use the function pattern from this concept: redefining a function.
3. Call the function with quoted arguments when values may contain spaces.
4. Match stdout and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

message() {
  echo "old"
}

message

message() {
  echo "new"
}

message
```
