# Guide for Handle Quoted Arguments

Goal: Loop over `"$@"` and print each argument on its own numbered line as `argN=<value>`. Quoted arguments containing spaces must remain intact.

Work in this order:

1. Start from `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Read the input using the curriculum concept for this level: quoting in `"$@"`.
3. Print only the required output, with quoted variable expansions.
4. Run the mission tests, including the failure or empty-input case when one is listed.

Reference shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

index=1
for arg in "$@"; do
  printf 'arg%s=%s
' "$index" "$arg"
  ((index += 1))
done
```
