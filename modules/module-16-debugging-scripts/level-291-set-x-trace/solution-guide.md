# Solution Guide: set -x Trace

This level focuses on `set -x`.

```bash
#!/usr/bin/env bash
set -euo pipefail

exec 3> trace.log
BASH_XTRACEFD=3
set -x
value="alpha"
result="${value}-done"
set +x
exec 3>&-
printf 'result=%s\n' "$result"
grep -q 'value=alpha' trace.log && echo 'trace=written'
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
