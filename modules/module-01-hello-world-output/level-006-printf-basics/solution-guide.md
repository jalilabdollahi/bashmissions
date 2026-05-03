# Guide for printf Basics

To format output, use printf with placeholders:

```bash
#!/usr/bin/env bash
set -euo pipefail

printf 'Name=%s; Score=%s\n' "$1" "$2"
```

- %s is a placeholder for a string.
- Always quote your variables.

Try building the script in this order:

1. Start the script with a bash shebang.
2. Read the first two command-line arguments from `$1` and `$2`.
3. Print the exact required text in one line: `Name=<arg1>; Score=<arg2>`.
4. Use quoted variables so inputs like `spaces allowed` still work correctly.

A working shape looks like this:

```bash
#!/usr/bin/env bash
set -euo pipefail

printf 'Name=%s; Score=%s\n' "$1" "$2"
```
