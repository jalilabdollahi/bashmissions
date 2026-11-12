# Debrief: Collect Job Results

## What you learned

Processes do not share variables; they share *files*. When parallel jobs
must report back, give each its own output file, so no two jobs ever write to
the same place, and read the files after `wait`. Reading in a fixed order
turns an unpredictable finishing order into a predictable report.

## Under the hood

A background job begins as a fork of your shell, with a private copy of every
variable. Assigning inside the job (or inside `$(...)`, or on the right side of a
pipe) changes that copy, which is discarded when the process ends. Exit status
is the only thing that comes back automatically; anything richer must travel
through a file, a pipe or the output stream.

Why one file per job and not one shared file? Several processes appending to
the same file can interleave their lines, and the order would depend on timing.
Separate files also let you see *which* job produced what.

`mktemp -d` gives a folder that no other process is using. Clean it up when
you finish, ideally with a `trap ... EXIT` so that it also disappears when the
script is interrupted (you wrote one in module 11).

## In real work

Parallel health checks, per-host deploy logs and test shards all collect results
this way. CI systems call the files "artifacts".

## Going further

Files are the slow lane. Next: a pipe with a name, so two processes can talk
to each other while both are running.
