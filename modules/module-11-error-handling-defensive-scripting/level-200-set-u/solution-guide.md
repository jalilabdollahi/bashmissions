# Solution Guide: set -u

This level focuses on abort on unset variable.

```bash
#!/usr/bin/env bash
set -u

if (set -u; echo "$missing_value") 2> unset.log; then
  echo "unexpected=success"
else
  echo "unset=blocked"
fi
```

The script demonstrates the failure-handling pattern while keeping the checker output deterministic.
