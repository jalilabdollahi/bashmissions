# Solution Guide: Pivot Table in Bash

This level focuses on assoc array aggregation.

```bash
#!/usr/bin/env bash
set -euo pipefail
declare -A sum
while IFS=, read -r region value; do
  [[ $region == region ]] && continue
  sum[$region]=$(( ${sum[$region]:-0} + value ))
done < fixtures/data.csv
for key in "${!sum[@]}"; do echo "$key=${sum[$key]}"; done | sort
```

The script uses a small fixture so the data operation is visible and deterministic.
