# Guide for All Arguments

Goal: Loop over all positional arguments safely with `"$@"` and print each one on its own numbered line as `N: <arg>`. Inputs containing spaces must stay one argument.

Work in this order:

1. Start from `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Read the input using the curriculum concept for this level: `$@` vs `$*`.
3. Print only the required output, with quoted variable expansions.
4. Run the mission tests, including the failure or empty-input case when one is listed.

Reference shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

index=1
for arg in "$@"; do
  printf '%s: %s
' "$index" "$arg"
  ((index += 1))
done
```
