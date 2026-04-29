# Guide for Print to Stderr

Try building the script in this order:

1. Start the script with a bash shebang.
2. Read the first argument from `$1`.
3. Print `Error: <arg1>` redirected to stderr with `>&2`.
4. Let stdout remain empty — nothing should be printed there.

A working shape looks like this:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "Error: $1" >&2
```

The `>&2` redirects the echo output from stdout (fd 1) to stderr (fd 2).

Write it yourself first if you can. If you are still blocked, use the `answer` command to inspect the reference solution.
