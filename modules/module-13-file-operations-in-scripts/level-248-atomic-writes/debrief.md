# Debrief: Atomic Writes

## What you learned

"Atomic" means all-or-nothing as far as everyone else is concerned. You get
it from a rename, not from careful writing: prepare the complete new file
privately, validate it, and make it visible with one `mv`. Readers see
either the whole old file or the whole new file.

## Under the hood

A directory is a table of names pointing at file contents. Renaming within
a disk rewrites one entry in that table, a single operation the kernel
performs indivisibly, replacing the old target in the same breath. Programs
that already have the old file open keep reading the old contents, which
stay alive until they close it.

On two different disks there is no such single operation, so `mv` falls back
to copy-and-delete. That is why the temp file lives next to the target, not
in `/tmp`.

Because the temp file is a *new* file, it carries new permissions and a
new owner: mode 600 from `mktemp`. Always set what the final file needs.

## In real work

Package managers, editors ("safe write" mode), databases and deploy tools
all write this way. Combined with validation it also gives you rollback for
free: a bad new file is simply never moved in.

## Going further

Atomic writes protect readers from half-written files. Backups protect
you from files that are wrong but complete. Next: keeping the last few
versions with rotation.
