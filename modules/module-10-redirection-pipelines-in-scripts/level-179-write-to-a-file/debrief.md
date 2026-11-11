# Debrief: Write to a File

## What you learned

A running program has numbered channels called file descriptors. Number 1 is
standard output, the place its normal results go. Your terminal is only the
default destination. `>` tells the shell: before starting this command, point
channel 1 at this file instead.

## Under the hood

The shell opens `report.txt` with the "write, create, truncate" flags, then
starts the command with that open file as its descriptor 1. The command never
sees the file name; it just writes to "1". Truncation happens the moment the
shell opens the file, even if the command then prints nothing. That is why
`> file` on its own, with no command, is a well-known trick to empty a file.

## In real work

Reports, exports, generated configs, last-run snapshots: whenever the result
of a command has to outlive the terminal session. Scripts rely on `>` for
any file that should always hold the latest state.

## Going further

Sometimes you do not want to lose the old content, you want to add to it,
like a log. That is the next level: `>>`.
