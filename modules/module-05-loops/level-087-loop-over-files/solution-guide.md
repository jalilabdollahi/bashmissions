# Guide for Loop over Files

Goal: Loop over `fixtures/*.txt` and print each matching basename. Ignore non-text files.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: `for f in *.txt`.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

for file in fixtures/*.txt; do
  basename "$file"
done
```
