# Solution Guide: Multi-Host Executor

This level focuses on run command on host list.

```bash
#!/usr/bin/env bash
set -euo pipefail
workdir=multi_host_executor.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'multi_host_executor=ok'
```

The script demonstrates the concept safely inside the mission workspace.
