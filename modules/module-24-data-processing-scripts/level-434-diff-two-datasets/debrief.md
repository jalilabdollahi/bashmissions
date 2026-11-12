# Debrief: Diff Two Datasets

The mental model: **a dataset is a mapping from keys to values, and a diff is
set arithmetic on the keys.** Keys only in the new set are additions, keys only
in the old set are removals, keys in both are candidates for change, and
"changed" means the values differ. This is how every sync tool, migration
checker and audit report thinks, from `rsync` to database replication.

Line-oriented `diff` answers a different question ("which lines must I edit to
turn A into B?"), and it is sensitive to order, which carries no meaning in a
keyed table. Keyed comparison ignores order entirely, so re-sorting a file can
no longer produce a false alarm. It also gives *changed* as a first-class
result with both values side by side, which line diffs can only show as a
delete plus an insert.

A few robustness decisions are visible in the code. Duplicate keys must be
decided somehow (last wins here, and it is written into the objective).
Empty or mismatched inputs fail loudly with a message, because an empty file
would otherwise look like "everything was removed". And the awk idiom
`FNR == NR` has a blind spot: with an empty first file it misidentifies the
second one. Checking for that case first is a cheap, honest fix.

Finally the shell trap: `grep -c` returns exit status 1 for a count of zero,
which is correct for grep ("nothing matched") and surprising under `set -e`.

Going further: when the same key appears many times *within one file*, you
usually want to keep a particular row. The next level keeps the most recent
one.
