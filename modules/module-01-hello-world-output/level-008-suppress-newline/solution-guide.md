# Guide for Suppress Newline

Try building the script in this order:

1. Start the script with a bash shebang.
2. Read the two arguments from `$1` and `$2`.
3. Use `echo -n` to print `LEVEL 8: Suppress Newline | <arg1> | <arg2>` without a trailing newline.

A working shape looks like this:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo -n "LEVEL 8: Suppress Newline | $1 | $2"
```

The `-n` flag suppresses the automatic newline that `echo` normally appends.

Write it yourself first if you can. If you are still blocked, use the `answer` command to inspect the reference solution.
