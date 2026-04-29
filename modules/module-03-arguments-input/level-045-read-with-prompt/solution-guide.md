# Guide for Read with Prompt

Goal: Use `read -r -p` to read a name from the file path in `$1`, then print `Name is: <value>`. The prompt itself is not part of the expected output in this non-interactive test.

Work in this order:

1. Start from `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Read the input using the curriculum concept for this level: `read -p "prompt" var`.
3. Print only the required output, with quoted variable expansions.
4. Run the mission tests, including the failure or empty-input case when one is listed.

Reference shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

read -r -p "Name: " name < "$1"
echo "Name is: $name"
```
