# Guide for Local vs Global Scope

Build the script in this order:

1. Start with the bash shebang.
2. Set `x="global"` at the top level.
3. Define a function `demo` that declares `local x="local"` and prints `inside: $x`.
4. Call `demo`, then print `outside: $x`.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

x="global"
demo() {
  local x="local"
  echo "inside: $x"
}
demo
echo "outside: $x"
```

Sanity check:

```bash
./solution.sh
# inside: local
# outside: global
```

Drop `local` and rerun: now both lines print `local`. Use `answer` if stuck.
