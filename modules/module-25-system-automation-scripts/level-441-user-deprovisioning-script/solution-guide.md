# Solution Guide: User Deprovisioning Script

This level focuses on lock + archive home.

```bash
#!/usr/bin/env bash
set -euo pipefail
workdir=user_deprovisioning_script.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'user_deprovisioning_script=ok'
```

The script demonstrates the concept safely inside the mission workspace.
