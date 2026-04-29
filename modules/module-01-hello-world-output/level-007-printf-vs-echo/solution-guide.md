# Guide for printf vs echo

Try building the script in this order:

1. Start the script with a bash shebang.
2. Use `printf` with the `%s` format specifier to print `$1` without escape interpretation.
3. Prefix the output with `raw: ` as required.

A working shape looks like this:

```bash
#!/usr/bin/env bash
set -euo pipefail

printf 'raw: %s\n' "$1"
```

The `%s` specifier treats the argument as a plain string — backslashes and special characters are printed literally.

Write it yourself first if you can. If you are still blocked, use the `answer` command to inspect the reference solution.
