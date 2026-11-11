# Walkthrough: Strip the Longest Prefix

## The plan
Loop over every argument and, for each path, delete everything up to and
including its last `/`.

## Why two hashes
With `#` the pattern `*/` would stop at the first slash: `/var/log/error.log`
would become `var/log/error.log`. With `##` the `*` stretches as far as it can,
as long as a `/` still follows, so only the text after the final slash survives:

```bash
file=${path##*/}
```

| value | `${v#*/}` | `${v##*/}` |
|---|---|---|
| `/var/log/error.log` | `var/log/error.log` | `error.log` |
| `readme.md` | `readme.md` | `readme.md` |
| `/var/backups/` | `var/backups/` | *(empty)* |

## Building it
Use `"$@"` (quoted) so a path with spaces counts as one argument:

```bash
for path in "$@"; do
  file=${path##*/}
  echo "$path -> $file"
done
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
for path in "$@"; do
  file=${path##*/}
  echo "$path -> $file"
done
```

## Try it by hand
```bash
./solution.sh /var/log/nginx/error.log readme.md /var/backups/
./solution.sh "/srv/tidewater books/Q3 report.pdf"
```

## Alternative
`basename "$path"` gives the same result for normal paths, but it starts a process
per path and quietly strips a trailing slash (`basename /var/backups/` prints
`backups`), which is a different answer from the one specified here. The
expansion also works inside a loop over thousands of paths without slowing down.
