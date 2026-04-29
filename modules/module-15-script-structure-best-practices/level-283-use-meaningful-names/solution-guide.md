# Solution Guide: Use Meaningful Names

This level focuses on naming conventions.

```bash
#!/usr/bin/env bash
set -euo pipefail

source_file="fixtures/data.txt"
destination_file="result.txt"
cp "$source_file" "$destination_file"
printf 'destination=%s\n' "$destination_file"
printf 'content=%s\n' "$(< "$destination_file")"
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
