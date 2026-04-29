# Solution Guide: Aggregate CSV Column

This level focuses on sum/avg/min/max.

```bash
#!/usr/bin/env bash
set -euo pipefail
awk -F, 'NR>1{sum+=$2; if(min==""||$2<min)min=$2; if($2>max)max=$2} END{print "sum="sum; print "min="min; print "max="max}' fixtures/data.csv
```

The script uses a small fixture so the data operation is visible and deterministic.
