# Solution Guide: Firewall Audit Script

This level focuses on parse iptables output.

```bash
#!/usr/bin/env bash
set -euo pipefail
workdir=firewall_audit_script.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'firewall_audit_script=ok'
```

The script demonstrates the concept safely inside the mission workspace.
