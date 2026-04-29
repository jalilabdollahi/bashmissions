# Solution Guide: Propagate Exit Codes

This level focuses on maintain exit code through functions.

```bash
#!/usr/bin/env bash
set -u

run_check() {
  grep -q "$1" fixtures/data.txt
  return $?
}

run_check delta
code=$?
echo "function_exit=$code"
exit 0
```

The script demonstrates the failure-handling pattern while keeping the checker output deterministic.
