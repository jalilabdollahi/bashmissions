# Guide for Print a Message

Try building the script in this order:

1. Start the script with a bash shebang.
2. Read the first command-line argument from `$1`.
3. Print it as `Message: <arg1>` on a single line.
4. Quote `$1` so spaces are preserved.

A working shape looks like this:

```bash
#!/usr/bin/env bash
set -euo pipefail

printf 'Message: %s\n' "$1"
```

Write it yourself first if you can. If you are still blocked, use the `answer` command to inspect the reference solution.
