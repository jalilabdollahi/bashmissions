# Solution Guide: Iterator over File

This level focuses on closure-style read.

```bash
#!/usr/bin/env bash
set -euo pipefail

exec 4< fixtures/data.txt
next_line(){ IFS= read -r line <&4 && echo "$line"; }
echo "next=$(next_line)"
echo "next=$(next_line)"
exec 4<&-
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
