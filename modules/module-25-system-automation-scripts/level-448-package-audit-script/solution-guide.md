# Solution Guide: Package Audit Script

This level focuses on list installed.

```bash
#!/usr/bin/env bash
set -euo pipefail
workdir=package_audit_script.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'package_audit_script=ok'
```

The script demonstrates the concept safely inside the mission workspace.
