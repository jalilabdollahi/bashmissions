# Guide for Redirect stderr to File

Try building the script in this order:

1. Start the script with a bash shebang.
2. Read the first two command-line arguments from `$1` and `$2`.
3. Print the exact required text in one line, preserving spaces inside each argument.
4. Use quoted variables so inputs like `spaces allowed` still work correctly.

A working shape looks like this:

```bash
#!/usr/bin/env bash
set -euo pipefail

printf 'LEVEL %s: %s | %s | %s\n' '180' 'Redirect stderr to File' "$1" "$2"
```

Write it yourself first if you can. If you are still blocked, use the `answer` command to inspect the reference solution.
