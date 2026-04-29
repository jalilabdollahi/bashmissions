# Solution Guide: Pass Auth Header

This level focuses on Bearer token.

```bash
#!/usr/bin/env bash
set -euo pipefail
token='secret-token'
header="Authorization: Bearer $token"
[[ $header == Authorization:* ]] && echo 'auth_header=ready'
```

The script demonstrates the concept safely inside the mission workspace.
