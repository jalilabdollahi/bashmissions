# Debrief: Copy with Checks

## What you learned

A command's exit status tells you what the *command* believes. For anything
valuable (backups, deploys, uploads) add an independent check that looks at
the *result*. Here that is `cmp -s`: do the two files really match?

The second lesson is ordering. Cheap, reversible checks come first (does
the source exist? will I overwrite something?), the action second, the
verification last, and a failed verification cleans up after itself.

## Under the hood

`cmp` reads both files in step and stops at the first difference; its exit
status is 0 (same), 1 (different) or 2 (trouble, such as a missing file).
`-s` suppresses its text output so the status alone drives your `if`. A
truncated copy has a different length, so it fails at the end of the shorter
file at the latest.

`basename` and its sibling `dirname` split a path at the last slash, without
looking at the disk.

## In real work

Backup scripts, release uploads and migrations all end with "verify the
destination". Real-life verifiers are `cmp`, `cksum` or checksums from
other tools. Distinct exit codes (1 bad input, 3 corrupt) let a scheduler
decide whether to retry.

## Going further

Copying keeps the original. Next: renaming many files at once by changing
their extension.
