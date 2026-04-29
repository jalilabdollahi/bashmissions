# Guide for Print Multiple Lines

To print multiple lines, use echo for each line:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "Line 1: $1"
echo "Line 2: $2"
echo "Done."
```

This prints three lines, each with the required format. Always quote your variables to preserve spaces.
