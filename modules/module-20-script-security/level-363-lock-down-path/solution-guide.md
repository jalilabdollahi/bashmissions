# Walkthrough: Lock Down PATH

## The plan
Make the very first real line of the script pin `PATH` to the system folders. The
rest of the script stays as it is.

## How command lookup works
For a name without a slash, Bash checks aliases, functions and builtins, then
searches every folder listed in `PATH` in order. Two sources of danger:

1. **A hostile folder early in the list**: the test puts `evil` first, with its
   own `ls`, `cat`, `wc` and `tr`.
2. **An empty entry**: in `:/usr/bin:/bin` the empty piece before the first colon
   means "the current folder". A file called `ls` in whatever folder the script
   runs from then beats the real one. A lone `.` has the same effect.

Cron, ssh and `sudo` environments all hand scripts different PATH values, so the
script cannot rely on the caller.

## Steps
1. Right after `set -euo pipefail`, write `PATH=/usr/bin:/bin`. It needs no
   `export`: a variable that already lives in the environment stays exported.
2. Keep the rest unchanged. The `ls -1 | wc -l | tr -d ' '` pipeline strips the
   padding macOS adds to `wc -l`.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
PATH=/usr/bin:/bin
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh DIR" >&2
  exit 2
fi
dir=$1
entries=$(ls -1 "$dir" | wc -l | tr -d ' ')
printf 'entries: %s\n' "$entries"
cat "$dir/motd.txt"
```

## Try it
```
mkdir -p evil; printf '#!/bin/sh\necho gotcha\n' > evil/ls; chmod +x evil/ls
mkdir -p spool; echo hi > spool/motd.txt
PATH=$PWD/evil:$PATH ./solution.sh spool
```

## Alternative
Call each tool by full path (`/bin/ls`). That is bulletproof for one command, but
noisy and different between systems (`/usr/bin/tr` versus `/bin/tr`). Pinning
PATH once is the usual compromise.
