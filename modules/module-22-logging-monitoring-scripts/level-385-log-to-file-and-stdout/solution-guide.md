# Solution Guide: Log to File and Stdout

This level focuses on tee.

```bash
#!/usr/bin/env bash
set -euo pipefail
echo 'build ok' | tee build.log
echo "logged=$(cat build.log)"
```

The script demonstrates the concept safely inside the mission workspace.
