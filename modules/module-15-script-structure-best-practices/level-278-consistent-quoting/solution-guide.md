# Solution Guide: Consistent Quoting

This level focuses on always quote variables.

```bash
#!/usr/bin/env bash
set -euo pipefail

file="two words.txt"
printf 'ok\n' > "$file"
printf 'content=%s\n' "$(< "$file")"
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
