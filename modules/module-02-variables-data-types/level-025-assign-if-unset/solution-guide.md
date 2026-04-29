# Guide for Assign If Unset

Build the script in this order:

1. Start with the bash shebang.
2. Copy `$1` into a named variable so `:=` can target it.
3. `: "${name:=guest}"` triggers the default-and-assign side-effect.
4. Print `Welcome, $name`.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

name="$1"
: "${name:=guest}"
echo "Welcome, $name"
```

Sanity check:

```bash
./solution.sh Jalil   # Welcome, Jalil
./solution.sh ""      # Welcome, guest
```

Try removing the leading `:` and Bash will try to run `guest` as a command. Use `answer` if stuck.
