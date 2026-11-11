# Debrief: Which File Is Newer?

Timestamps turn into one-word comparisons. `-nt` and `-ot` are the core of
every "rebuild only when something changed" idea, the same trick `make` uses to
decide what needs recompiling.

## Under the hood

Every file records a modification time (mtime), the last moment its contents
changed. `a -nt b` compares the two mtimes; it does not read the files. If `b`
is missing, Bash treats it as older than anything that exists; if `a` is
missing, `-nt` is false. Equal mtimes make both operators false, which is why
the else-branch should be designed with that case in mind.

Be careful what "modified" means. Copying a file creates a new file with the
current time unless you preserve times (`cp -p`), and `touch` can set any time
you like. A backup job that copies without `-p` will look fresher than the
source it protects.

## Where it shows up

Build scripts, cache invalidation, "regenerate the report if the data changed",
and sanity checks such as "is this log still being written to?".

## Going further

The tests so far looked at the file system. Next, a different kind of matching:
file names themselves, using wildcards inside `[[ ]]`.
