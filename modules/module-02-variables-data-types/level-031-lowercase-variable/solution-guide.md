# Guide for Lowercase Variable

Build the script in this order:

1. Start with the bash shebang.
2. Copy `$1` into a named variable.
3. Print `${text,,}`.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

text="$1"
echo "${text,,}"
```

Sanity check:

```bash
./solution.sh HELLO       # hello
./solution.sh "MiXeD CaSe" # mixed case
```

Compare with `${text,}` (single comma) which only touches the first character. Use `answer` if stuck.
