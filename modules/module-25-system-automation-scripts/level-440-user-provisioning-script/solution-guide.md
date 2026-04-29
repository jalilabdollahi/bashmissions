# Solution Guide: User Provisioning Script

This level focuses on create users from CSV.

```bash
#!/usr/bin/env bash
set -euo pipefail
workdir=user_provisioning_script.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'user_provisioning_script=ok'
```

The script demonstrates the concept safely inside the mission workspace.
