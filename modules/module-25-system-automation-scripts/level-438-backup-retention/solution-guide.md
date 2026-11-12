# Walkthrough: Backup Retention

## The plan

Retention is a decision per file, and the decision only needs two facts: how
new the file is (its position in the sorted list) and whether it was made on a
Sunday (its name). No date arithmetic is needed because the job already put
both facts into the name.

## Building it

Parse the flag first. `-n` is optional, so check `${1:-}`, set `dry=1` and
`shift`; after that there must be exactly one argument left.

Collect the archives into an array. With `shopt -s nullglob`, a folder without
matches yields an empty array. Glob results are sorted by name, so index 0 is
the oldest archive.

If there are `total` archives, the 7 newest have indexes `total-7` and up.
For a short list the threshold goes negative, which is fine: every index is
then `>=` it, so everything counts as daily.

Walk the indexes with `for i in "${!archives[@]}"`. Three branches decide the
verdict: newest, Sunday, or neither. Only the third branch removes anything,
and it removes only when `dry` is off. Keep two counters for the summary.

Strip the folder from names for display with `${path##*/}`, because the
objective shows bare file names.

## Complete solution

See answer.sh: option, validation, array, loop with three branches, summary.

## Trying it by hand

```
mkdir backups; cd backups
for d in 20260301-Sun 20260302-Mon 20260303-Tue; do touch www-$d.tar.gz; done
cd ..; ./solution.sh -n backups
```

## Alternative

`ls | sort | head -n -7` style pipelines work on GNU but `head -n -7` is not
portable. An array with indexes is the portable way, and it also makes the
weekly rule trivial.
