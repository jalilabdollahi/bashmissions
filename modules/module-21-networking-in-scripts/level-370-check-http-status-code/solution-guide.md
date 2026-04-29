# Solution Guide: Check HTTP Status Code

This level focuses on `curl -o /dev/null -w "%{http_code}"`.

```bash
#!/usr/bin/env bash
set -euo pipefail
echo ok > page.txt
code=$(curl -s -o /dev/null -w '%{http_code}' "file://$PWD/page.txt")
echo "code=$code"
```

The script demonstrates the concept safely inside the mission workspace.
