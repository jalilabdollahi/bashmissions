# Walkthrough: Database Dump Rotation

## The plan

Rotation has two halves, adding a dump and removing old ones, and the order
is the entire safety story. Add and verify first; remove last, and only if
the first half fully succeeded.

## Building it

Validate the inputs. The database name is checked against a strict regex
because it becomes part of a file name (`../etc` must not get through), and
KEEP must be a whole number of at least 1. A KEEP of 0 would let a successful
run delete the dump it just made.

The dump is a pipeline, `pg_dump --no-owner "$db" | gzip > "$partial"`. In a
pipeline Bash normally reports only the last command's status, so a crashed
pg_dump followed by a happy gzip looks like success and leaves a truncated
file. `set -o pipefail` changes that: the pipeline fails if any stage fails.
Use the pipeline as an `if` condition so the failure branch can clean up (`rm
-f` the partial), print the message, and exit before the pruning code is
reached.

On success, `gzip -t` confirms the file is a valid gzip stream and `mv`
renames it into place. Only the rename makes a dump visible.

Pruning uses a precise glob: `"$outdir/$db"-[0-9]*.sql.gz`. Requiring a digit
after the dash is what keeps `app-staging-20260101.sql.gz` out of `app`'s
list. Globs sort by name, and with date stamps that is oldest first, so the
first `count - keep` entries are the ones to delete.

## Complete solution

See answer.sh.

## Trying it by hand

```
mkdir -p fixtures/db; echo 'select 1;' > fixtures/db/app.sql
./solution.sh app backups 20260301 2; ls backups
```

## Alternative

Prune first to "make room" is tempting when disks are tight, but it is the
one order that can leave you with nothing.
