# Solution Guide: Avoid Parsing ls

This level focuses on use glob/find instead.

```bash
#!/usr/bin/env bash
set -euo pipefail
mkdir -p files
touch files/a.txt files/b.txt
for file in files/*.txt; do basename "$file"; done | sort
```

The script demonstrates the concept safely inside the mission workspace.
