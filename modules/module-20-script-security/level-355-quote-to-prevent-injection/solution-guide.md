# Solution Guide: Quote to Prevent Injection

This level focuses on `"$var"` vs eval danger.

```bash
#!/usr/bin/env bash
set -euo pipefail
name='alpha; touch hacked'
printf 'safe=<%s>\n' "$name"
printf 'hacked=%s\n' "$([[ -e hacked ]] && echo yes || echo no)"
```

The script demonstrates the concept safely inside the mission workspace.
