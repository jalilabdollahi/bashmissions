# Solution Guide: Match an IP Address

This level focuses on IP regex pattern.

```bash
#!/usr/bin/env bash
set -euo pipefail

ip=${1:-}
octet='(25[0-5]|2[0-4][0-9]|1?[0-9]?[0-9])'
regex="^$octet\.$octet\.$octet\.$octet$"
if [[ $ip =~ $regex ]]; then
  echo "ip=valid"
else
  echo "ip=invalid"
fi
```

The script keeps the regex focused and prints only the deterministic result expected by the checker.
