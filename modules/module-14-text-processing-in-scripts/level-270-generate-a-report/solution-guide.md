# Solution Guide: Generate a Report

This level focuses on combine awk+sort+head.

```bash
#!/usr/bin/env bash
set -euo pipefail

awk -F, 'NR > 1 {print $3, $1}' fixtures/data.txt | sort -rn | head -2 | awk '{print $2 "=" $1}'
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
