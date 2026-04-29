# Solution Guide: Exit on Failure

This level focuses on `cmd || exit 1`.

```bash
#!/usr/bin/env bash
set -u

mkdir -p output || exit 1
echo "created=output"
```

The script demonstrates the failure-handling pattern while keeping the checker output deterministic.
