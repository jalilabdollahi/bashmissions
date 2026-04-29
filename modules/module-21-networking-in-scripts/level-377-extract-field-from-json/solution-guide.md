# Solution Guide: Extract Field from JSON

This level focuses on `jq -r '.field'`.

```bash
#!/usr/bin/env bash
set -euo pipefail
echo '{"name":"api"}' | jq -r '.name'
```

The script demonstrates the concept safely inside the mission workspace.
