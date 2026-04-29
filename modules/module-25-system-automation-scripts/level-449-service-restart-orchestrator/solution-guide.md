# Solution Guide: Service Restart Orchestrator

This level focuses on rolling restart.

```bash
#!/usr/bin/env bash
set -euo pipefail
workdir=service_restart_orchestrator.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'service_restart_orchestrator=ok'
```

The script demonstrates the concept safely inside the mission workspace.
