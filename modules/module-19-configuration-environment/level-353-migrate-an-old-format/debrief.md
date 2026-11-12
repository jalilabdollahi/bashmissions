# Debrief: Migrate an Old Format

The mental model: **a migration is a transaction you cannot roll back, so make it safe
before making it clever.** The data belongs to someone else, and a bug in your tool
should cost a re-run, not a customer's configuration. Three safeguards did the work
here. Non-destructive: the old file is only read. Non-overwriting: an existing new
file is evidence that somebody already did something, so the tool stops. Idempotent:
a file that already carries `version=2` is recognised and left alone, which makes it
safe to run the migration from a deploy script on every release.

The second lesson is about what a "rename" really is. Some changes are mechanical
(`Listen` to `port`); others change meaning (`Debug: on` becomes a level, `30s` becomes
`30`). Writing them as an explicit table makes every decision reviewable. And unknown
data is carried across with a warning instead of being dropped; data loss during an
upgrade is almost never what the owner wants.

Technically, "build the output in memory and write it once" means that a crash in the
middle cannot leave a half-written file that the next run mistakes for a finished
one. For larger files, the same idea is "write to a temporary name, then `mv`".

Going further: after migrating, you will want to see exactly what changed between two
config files, additions, removals, edits. That comparison is the last level of the
module.
