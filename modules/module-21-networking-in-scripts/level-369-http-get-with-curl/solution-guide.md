# Solution Guide: HTTP GET with curl

This level focuses on `curl -s URL`.

```bash
#!/usr/bin/env bash
set -euo pipefail
echo 'hello http' > page.txt
curl -s "file://$PWD/page.txt"
```

The script demonstrates the concept safely inside the mission workspace.
