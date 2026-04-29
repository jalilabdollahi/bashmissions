# Guide for Print Version Info

Build the script in this order:

1. Start with the bash shebang.
2. Copy the two arguments into named variables: `name="$1"`, `version="$2"`.
3. `echo` them in a double-quoted string with the literal word `version` between.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

name="$1"
version="$2"
echo "$name version $version"
```

Sanity check:

```bash
./solution.sh mytool 1.2.3
# mytool version 1.2.3
./solution.sh app v0.1
# app version v0.1
```

`printf '%s version %s\n' "$name" "$version"` is an equally valid form. Use `answer` if stuck.
