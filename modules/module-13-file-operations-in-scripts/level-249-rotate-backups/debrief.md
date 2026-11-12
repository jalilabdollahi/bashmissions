# Debrief: Rotate Backups

## What you learned

Rotation is shifting along a line of slots. The rule that makes it safe is
**move the oldest first**: every destination must be free before something
is moved into it. Combined with "only move what exists", the same few lines
handle a first run, a full set and a series with gaps.

## Under the hood

Each `mv` here is a rename within one folder, cheap and atomic for each
step. A crash between two steps can leave a gap (for example `.2` missing),
which this script treats as normal, one more reason skipping absent slots
matters. The newest copy is made last, so even a crash in the middle never
leaves you with fewer *old* backups than you had.

Notice what keeps the number at three: nothing counts them. The oldest slot
is simply overwritten or removed each time. Fixed-size history by construction
is easier to reason about than "delete anything beyond three".

## In real work

This is how `logrotate` names `syslog.1`, `syslog.2.gz` and so on. The same
pattern keeps the last N database dumps, N config versions or N screenshots.

## Going further

You now have a toolbox: create, protect, copy, find, lock, swap, rotate.
In the final level of this module you will combine reading a tree with
counting: a summary of a folder by file type.
