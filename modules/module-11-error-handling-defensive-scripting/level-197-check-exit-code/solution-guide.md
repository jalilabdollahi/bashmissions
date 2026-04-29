# Solution Guide: Check Exit Code

This level focuses on `$?` after command.

```bash
#!/usr/bin/env bash
set -u

grep -q beta fixtures/data.txt
code=$?
echo "grep_exit=$code"
```

The script demonstrates the failure-handling pattern while keeping the checker output deterministic.
