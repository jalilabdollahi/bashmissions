# Solution Guide: Process Alive Check

This level focuses on pidfile pattern.

```bash
#!/usr/bin/env bash
set -euo pipefail
echo $$ > app.pid
pid=$(< app.pid)
kill -0 "$pid" 2>/dev/null && echo 'alive=yes'
```

The script demonstrates the concept safely inside the mission workspace.
