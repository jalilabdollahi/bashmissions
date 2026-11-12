# Debrief: Temporary Files

## What you learned

A script that needs scratch space should ask the system for it with
`mktemp`, use it, and clean up. Never invent a fixed name. The scratch file
also solves the classic trap of reading and writing the same file in one
pipeline.

## Under the hood

`mktemp` generates a random suffix and creates the file with an "exclusive"
flag: the kernel only succeeds if the name was free, so two scripts can
never end up sharing a file. It also creates it readable by you alone
(mode 600), which matters when the content is private. With no template it
places the file in `$TMPDIR`, falling back to `/tmp`.

The `trap ... EXIT` line is your cleanup guarantee. Bash runs it when the
script finishes normally, when `set -e` aborts it, and on `exit 1`. (A
`kill -9` is the one thing it cannot catch.)

## In real work

Every non-trivial script has a scratch file somewhere: merging exports,
building a config before installing it, holding a command's output while
you inspect it twice. Printing the temp path in a message is fine; relying on
a particular name is not.

## Going further

One file is easy to clean up. What about a whole workspace with many files
and folders? Next: `mktemp -d`.
