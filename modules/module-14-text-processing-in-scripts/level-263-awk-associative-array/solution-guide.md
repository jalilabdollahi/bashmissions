# Solution Guide: awk Associative Array

This level focuses on frequency count.

```bash
#!/usr/bin/env bash
set -euo pipefail

awk '{count[$1]++} END {for (k in count) print k "=" count[k]}' fixtures/data.txt | sort
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
