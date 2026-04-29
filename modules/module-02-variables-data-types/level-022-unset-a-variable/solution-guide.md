# Guide for Unset a Variable

Build the script in this order:

1. Start with the bash shebang.
2. Assign `$1` to a variable.
3. Print `before: <value>`.
4. `unset` the variable.
5. Print `after: ${v:-empty}` — the fallback covers the now-unset case.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

v="$1"
echo "before: $v"
unset v
echo "after: ${v:-empty}"
```

Sanity check:

```bash
./solution.sh hello
# before: hello
# after: empty
```

Try replacing `unset v` with `v=` and notice the output is the same — `${v:-empty}` treats empty and unset the same way. Use `answer` if stuck.
