# Debrief: Safe Temp Files

Temporary files are a classic attack surface because the folder is shared and
the check "does this name exist?" and the act "create it" are two separate
steps. An attacker who can predict the name wins the gap: they plant a symlink,
a pipe, or their own file, and your script writes where *they* chose, with *your*
privileges.

`mktemp` closes the gap. It generates the name from random characters and opens
the file with the exclusive-create flag in one system call, so it either creates
a brand-new file (private, mode 600) or fails. There is no window to race. The
`trap ... EXIT` half of the habit is about hygiene: scratch files that outlive the
script can hold customer data. Because the trap runs on `exit`, on `set -e`
failures and on Ctrl-C (which ends the script), it is far more reliable than an
`rm` at the bottom.

Things not to use as protection: `$$` (guessable), the clock, `$RANDOM` (a
weak 15-bit number), or a file name that merely "looks unique".

Use `mktemp -d` when you need a whole private folder, and keep the template under
`$TMPDIR` so tests and users can redirect it.

Going further: mktemp makes the *file* private. Level 359 makes every file your
script creates private from the first byte, using `umask`.
