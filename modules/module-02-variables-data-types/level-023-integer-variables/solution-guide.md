# Guide for Integer Variables

Build the script in this order:

1. Start with the bash shebang.
2. Declare an integer variable: `declare -i n="$1"`.
3. Add 10 with the compound operator: `n+=10`.
4. Print `$n`.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

declare -i n="$1"
n+=10
echo "$n"
```

Sanity check:

```bash
./solution.sh 5     # 15
./solution.sh 100   # 110
./solution.sh -3    # 7
```

Try removing the `-i` flag and re-run with `5` — you'll get `510` instead. Equivalent forms: `n=$((n + 10))` or `(( n += 10 ))`. Use `answer` if stuck.
