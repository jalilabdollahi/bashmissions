# Walkthrough: Constants Block

## The plan
Move every setting into one labelled block at the top, declared with `readonly`, and
refer to the names everywhere else. The starter has two weaknesses: values are
scattered, and `${BACKUP_ROOT:-/srv/backups}` means "use the caller's value if there
is one".

## Steps
1. Under `set -euo pipefail`, add the block:
   ```bash
   readonly BACKUP_ROOT=/srv/backups
   readonly KEEP_DAYS=14
   readonly SUFFIX=tar.gz
   ```
2. Delete the `root=` line. The environment fallback is what let `BACKUP_ROOT=/tmp/evil`
   win. A plain assignment in the script runs *after* the environment was inherited,
   so it replaces the inherited value.
3. Print with the names:
   ```bash
   echo "path=$BACKUP_ROOT/$1/$2.$SUFFIX"
   echo "keep=$KEEP_DAYS days"
   ```
   The dot between `$2` and `$SUFFIX` is fine: `.` cannot be part of a variable name.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
readonly BACKUP_ROOT=/srv/backups
readonly KEEP_DAYS=14
readonly SUFFIX=tar.gz

if [ "$#" -lt 2 ]; then
  echo "usage: solution.sh HOST DATE" >&2
  exit 2
fi
echo "path=$BACKUP_ROOT/$1/$2.$SUFFIX"
echo "keep=$KEEP_DAYS days"
```

## Try it
```
./solution.sh halibut 2026-03-01
BACKUP_ROOT=/tmp/evil ./solution.sh halibut 2026-03-01   # still /srv/backups
```

## Alternative
Plain variables with UPPER_CASE names work until a later line accidentally assigns
one. `readonly` turns that slip into an immediate error, so the bug surfaces in the
first test run instead of during a restore.
