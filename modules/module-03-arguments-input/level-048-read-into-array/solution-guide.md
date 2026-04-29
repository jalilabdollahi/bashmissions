# Guide for Read into Array

Goal: Use `read -r -a words` to split the first line of the file path in `$1` into an array. Print `count=<n> first=<first> last=<last>`.

Work in this order:

1. Start from `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Read the input using the curriculum concept for this level: `read -a arr`.
3. Print only the required output, with quoted variable expansions.
4. Run the mission tests, including the failure or empty-input case when one is listed.

Reference shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

read -r -a words < "$1"
last_index=$((${#words[@]} - 1))
printf 'count=%s first=%s last=%s
' "${#words[@]}" "${words[0]}" "${words[$last_index]}"
```
