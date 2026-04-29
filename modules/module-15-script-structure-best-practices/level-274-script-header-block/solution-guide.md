# Solution Guide: Script Header Block

This level focuses on name, author, usage, description.

```bash
#!/usr/bin/env bash
# Name: report-status
# Author: BashMissions
# Usage: report-status [environment]
# Description: Demonstrates a documented script header.
set -euo pipefail

grep -E '^# (Name|Usage|Description):' "$0" | sed 's/^# //'
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
