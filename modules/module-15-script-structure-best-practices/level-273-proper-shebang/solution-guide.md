# Solution Guide: Proper Shebang

This level focuses on `#!/usr/bin/env bash`.

```bash
#!/usr/bin/env bash
set -euo pipefail

read -r first_line < "$0"
echo "shebang=$first_line"
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
