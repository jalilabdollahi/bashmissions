# Guide for Escape Characters

To print special characters like backslashes and double quotes, use printf and escape them:

```bash
#!/usr/bin/env bash
set -euo pipefail

printf 'File: C:\\tmp\\%s | Quote: "%s"\n' "$1" "$2"
```

- Use \\ for a single backslash in output.
- Use \" for a double quote in output.
- Always quote your variables.
