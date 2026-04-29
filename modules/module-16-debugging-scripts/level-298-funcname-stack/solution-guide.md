# Solution Guide: FUNCNAME Stack

This level focuses on `${FUNCNAME[@]}`.

```bash
#!/usr/bin/env bash
set -euo pipefail

inner() {
  printf 'stack=%s>%s\n' "${FUNCNAME[0]}" "${FUNCNAME[1]}"
}
outer() {
  inner
}
outer
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
