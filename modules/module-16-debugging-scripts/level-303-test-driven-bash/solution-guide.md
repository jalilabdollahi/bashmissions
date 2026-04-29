# Solution Guide: Test-Driven Bash

This level focuses on write tests for your function.

```bash
#!/usr/bin/env bash
set -euo pipefail

slugify() {
  local input=$1
  printf '%s\n' "${input// /-}"
}

actual=$(slugify "hello bash")
if [[ $actual == "hello-bash" ]]; then
  echo "test=pass"
else
  echo "test=fail"
  exit 1
fi
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
