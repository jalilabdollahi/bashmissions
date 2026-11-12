# Walkthrough: Timestamped Backup

## The plan

A backup script has to be boring and safe: it must never destroy an older
backup, never store machine-specific paths, and it should look inside what it
just wrote. The name carries a stamp that the caller supplies, so the script is
deterministic and easy to schedule.

## Building it

Validate first. Exactly three arguments, and the source must be a directory:

```bash
[[ $# -eq 3 ]] || { echo "usage: solution.sh SRC DEST STAMP" >&2; exit 2; }
```

Strip a trailing slash with `${1%/}`, then split the path into the folder name
and its parent with `basename` and `dirname`. This is what keeps `site/` and
`site` identical.

Refuse to overwrite: test `-e` on the archive path before calling tar.

The important flag is `-C`. `tar -czf "$archive" -C "$parent" "$name"` first
moves into the parent folder, so the archive contains `name/index.html`, not
`/srv/www/name/index.html`. A restore then recreates one tidy folder anywhere.

Finally list the archive back with `tar -tzf`. Directory entries end in `/`, so
`grep -vc '/$'` counts regular files. `grep -c` exits with status 1 when it
counts zero, which `set -e -o pipefail` would treat as a failure, hence
`|| true`.

## Complete solution

See answer.sh: argument check, directory check, path split, mkdir, overwrite
guard, tar, count, two output lines.

## Trying it by hand

```
mkdir -p www/css && echo hi > www/index.html
./solution.sh www backups 20260301
tar -tzf backups/www-20260301.tar.gz
```

Run it twice: the second run must refuse.

## Alternative

You could `cd "$parent"` in a subshell instead of using `-C`. That works, but
`-C` keeps the script's own working directory unchanged, so relative DEST paths
keep meaning what the caller meant.
