# Guide for The Deployment Pipeline

Try building the script in this order:

1. Read the input path from `$1` and the optional mode from `$2`.
2. If the input file is missing, exit with status `1` and print nothing.
3. Default the mode to `ok` when no second argument is provided.
4. Print `the-deployment-pipeline:457:expert:<mode>` for the success path.

A working shape looks like this:

```bash
#!/usr/bin/env bash
set -euo pipefail

input=${1:-}
mode=${2:-ok}

[ -f "$input" ] || exit 1
printf '%s\n' 'the-deployment-pipeline:457:expert:'"$mode"
```

Write it yourself first if you can. If you are still blocked, use the `answer` command to inspect the reference solution.
