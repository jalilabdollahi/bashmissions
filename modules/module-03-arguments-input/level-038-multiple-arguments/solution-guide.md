# Guide for Multiple Arguments

Goal: Print the first three positional arguments in the format `first=<arg1> second=<arg2> third=<arg3>`. Use `$1`, `$2`, and `$3` directly, with quotes around every expansion.

Work in this order:

1. Start from `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Read the input using the curriculum concept for this level: `$1 $2 $3`.
3. Print only the required output, with quoted variable expansions.
4. Run the mission tests, including the failure or empty-input case when one is listed.

Reference shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

printf 'first=%s second=%s third=%s
' "$1" "$2" "$3"
```
