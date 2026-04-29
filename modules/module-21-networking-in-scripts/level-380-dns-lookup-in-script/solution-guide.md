# Solution Guide: DNS Lookup in Script

This level focuses on `dig`, `nslookup`.

```bash
#!/usr/bin/env bash
set -euo pipefail

if command -v dig >/dev/null || command -v nslookup >/dev/null; then
  echo 'dns_tool=found'
else
  echo 'dns_tool=missing'
fi
```

The script checks that a DNS lookup tool is available without depending on external resolver behavior.
