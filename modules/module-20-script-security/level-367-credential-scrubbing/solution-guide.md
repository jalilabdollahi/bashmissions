# Solution Guide: Credential Scrubbing

This level focuses on clear vars after use.

```bash
#!/usr/bin/env bash
set -euo pipefail
TOKEN='secret-value'
[[ -n $TOKEN ]] && echo 'used=yes'
unset TOKEN
echo "token_set=$([[ -v TOKEN ]] && echo yes || echo no)"
```

The script demonstrates the concept safely inside the mission workspace.
