# Guide for Single vs Double Quotes

Try building the script in this order:

1. Start the script with a bash shebang.
2. Save the first argument in `name`.
3. Print `single: $name` using single quotes.
4. Print `double: <arg1>` using double quotes.

A working shape looks like this:

```bash
#!/usr/bin/env bash
set -euo pipefail

name="$1"
echo 'single: $name'
echo "double: $name"
```

Write it yourself first if you can. If you are still blocked, use the `answer` command to inspect the reference solution.
