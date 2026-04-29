# Guide for Read Silently

Goal: Use `read -r -s` to read a password from the file path in `$1`, then print only `Password length: N`, where `N` is the number of characters. Do not print the password.

Work in this order:

1. Start from `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Read the input using the curriculum concept for this level: `read -s` for passwords.
3. Print only the required output, with quoted variable expansions.
4. Run the mission tests, including the failure or empty-input case when one is listed.

Reference shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

read -r -s password < "$1"
printf 'Password length: %s
' "${#password}"
```
