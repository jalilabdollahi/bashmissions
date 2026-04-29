# Solution Guide: Slice an Array

This level focuses on `${arr[@]:start:len}`.

```bash
#!/usr/bin/env bash
set -euo pipefail

words=(zero one two three four)
printf '%s\n' "${words[@]:1:3}"
```

The script keeps the array operation small and visible, then prints deterministic output for the checker.
