# Guide for Multi-line String

Build the script in this order:

1. Start with the bash shebang.
2. Open a heredoc with `cat <<EOF`.
3. Write the three lines verbatim.
4. Close the heredoc with `EOF` on its own line, at column 1.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

cat <<EOF
line one
line two
line three
EOF
```

Sanity check:

```bash
./solution.sh
# line one
# line two
# line three
```

Try the same with `<<'EOF'` and notice that `$HOME` would print literally instead of expanding. Use `answer` if stuck.
