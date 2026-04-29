# Solution Guide: Sanitize User Input

This level focuses on strip dangerous chars.

```bash
#!/usr/bin/env bash
set -euo pipefail
input='bad;name$(rm) ok'
clean=$(printf '%s' "$input" | tr -cd 'A-Za-z0-9._-')
echo "clean=$clean"
```

The script demonstrates the concept safely inside the mission workspace.
