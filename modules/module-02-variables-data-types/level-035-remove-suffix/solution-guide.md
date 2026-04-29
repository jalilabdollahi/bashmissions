# Guide for Remove Suffix

Build the script in this order:

1. Start with the bash shebang.
2. Copy `$1` into a named variable.
3. Print `${filename%.*}`.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

filename="$1"
echo "${filename%.*}"
```

Sanity check:

```bash
./solution.sh report.pdf      # report
./solution.sh archive.tar.gz  # archive.tar
./solution.sh noext           # noext   (no change)
```

Try `${filename%%.*}` to compare longest-match behaviour. Use `answer` if stuck.
