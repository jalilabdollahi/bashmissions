# Guide for Timeout Decorator

Try building the script in this order:

1. Read the input file path from `$1`.
2. Exit with status `1` and print nothing if the file does not exist.
3. Print `timeout-decorator:339:processed:3` when the file exists.
4. If the second argument is `verbose`, append `:verbose` to the output.

A working shape looks like this:

```bash
#!/usr/bin/env bash
set -euo pipefail

input=${1:-}
mode=${2:-}

[ -f "$input" ] || exit 1

output='timeout-decorator:339:processed:3'
[ "$mode" = 'verbose' ] && output+=':verbose'
printf '%s\n' "$output"
```

Write it yourself first if you can. If you are still blocked, use the `answer` command to inspect the reference solution.
