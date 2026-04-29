# Solution Guide: Changelog Generator

This level focuses on git log formatting.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
- fix bug
- add feature
OUT
cat result.txt
```

The script demonstrates the concept safely inside the mission workspace.
