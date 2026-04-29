# Solution Guide: Custom PS4

This level focuses on show file/line in trace.

```bash
#!/usr/bin/env bash
set -euo pipefail

exec 3> trace.log
BASH_XTRACEFD=3
PS4='+${LINENO}: '
set -x
name="api"
set +x
exec 3>&-
printf 'name=%s\n' "$name"
grep -Eq '^\+[0-9]+: name=api' trace.log && echo 'ps4=line'
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
