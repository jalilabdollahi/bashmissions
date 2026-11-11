# Debrief: Close and Restore

## What you learned

Descriptors can be copied, so you can keep a spare pointer to the original
destination, change the real one, and put it back. `exec 4>&1` saves,
`exec >file` redirects the script's own output, `exec 1>&4 4>&-` restores and
cleans up.

## Under the hood

Every process has a table of numbered slots, each pointing at an open file
(terminal, file, pipe). `4>&1` is `dup2(1, 4)`: slot 4 now points at the same
open file as slot 1. Re-pointing slot 1 later does not move slot 4, which is
why it works as a bookmark. Child processes copy the table when started, so
`compile-site` sees the file in slot 1 without knowing anything about it.

Closing with `4>&-` matters: an unclosed spare is inherited by every
later command and, for pipes, can keep readers waiting forever.

## In real work

Wrapping a noisy library call, silencing a section of an installer, sending
the output of a function to a log while a progress bar uses the terminal.

## Going further

The same trick has a tidier cousin for a single chunk of code: the redirected
block. That is the final level.
