# Solution Guide: die() Function

This level focuses on unified error exit.

```bash
#!/usr/bin/env bash
set -u

die() {
  echo "error: $*"
  exit 2
}

if [[ ${1:-} != ok ]]; then
  die "expected ok"
fi
echo "status=ok"
```

The script demonstrates the failure-handling pattern while keeping the checker output deterministic.
