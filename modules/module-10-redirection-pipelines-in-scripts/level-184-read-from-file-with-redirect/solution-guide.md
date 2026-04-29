# Solution Guide: Read from File with Redirect

This level focuses on `cmd < file`.

```bash
#!/usr/bin/env bash
set -euo pipefail

file=${1:?provide a file}
IFS= read -r first < "$file"
echo "first=$first"
```

The key is to use the redirection or pipeline operator for the work, then print deterministic output for the mission checker.
