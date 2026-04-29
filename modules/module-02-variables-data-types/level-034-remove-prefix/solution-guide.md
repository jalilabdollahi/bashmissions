# Guide for Remove Prefix

Build the script in this order:

1. Start with the bash shebang.
2. Copy `$1` into a named variable.
3. Print `${filename#*.}`.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

filename="$1"
echo "${filename#*.}"
```

Sanity check:

```bash
./solution.sh file.tar.gz   # tar.gz
./solution.sh report.pdf    # pdf
./solution.sh a.b.c.d       # b.c.d
```

Try `${filename##*.}` to see longest-match behaviour. Use `answer` if stuck.
