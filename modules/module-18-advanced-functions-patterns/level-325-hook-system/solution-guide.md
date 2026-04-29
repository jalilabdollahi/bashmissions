# Solution Guide: Hook System

This level focuses on pre/post hook arrays.

```bash
#!/usr/bin/env bash
set -euo pipefail

pre(){ echo pre; }
post(){ echo post; }
declare -a pre_hooks=(pre) post_hooks=(post)
for hook in "${pre_hooks[@]}"; do "$hook"; done
echo main
for hook in "${post_hooks[@]}"; do "$hook"; done
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
