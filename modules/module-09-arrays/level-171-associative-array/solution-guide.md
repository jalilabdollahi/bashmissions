# Solution Guide: Associative Array

This level focuses on `declare -A map`.

```bash
#!/usr/bin/env bash
set -euo pipefail

declare -A capitals=([france]=paris [japan]=tokyo)
echo "france=${capitals[france]}"
echo "japan=${capitals[japan]}"
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
