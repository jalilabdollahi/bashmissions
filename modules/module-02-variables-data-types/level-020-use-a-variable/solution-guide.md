# Guide for Use a Variable

Build the script in this order:

1. Start with the bash shebang.
2. Copy `$1` into a named variable.
3. Print `${name}_suffix` — note the braces.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

name="$1"
echo "${name}_suffix"
```

Sanity check:

```bash
./solution.sh foo       # foo_suffix
./solution.sh app       # app_suffix
```

Try removing the braces — `echo "$name_suffix"` — and watch the script either print empty (without `set -u`) or abort (with it). Use `answer` if stuck.
