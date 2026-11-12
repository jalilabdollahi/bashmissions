# Debrief: Compare Two Outputs

## What you learned

`<( command )` turns a command's output into something with a file name. Any
program that insists on file arguments can then read live output: `diff`,
`comm`, `paste`, `join`, `grep -f`.

## Under the hood

The shell creates a pipe, starts the command writing into one end, and
replaces the `<(...)` text with the path of the other end, typically
`/dev/fd/63`. When `diff` opens that path it reads from the pipe. Nothing
touches the disk. Because it is a pipe and not a file, the reader cannot seek
or read it twice, so tools that need two passes over one input will
misbehave.

Unlike `cmd1 | cmd2`, process substitution can feed several streams to one
command at once. It is a Bash feature, not part of plain POSIX `sh`.

## In real work

Comparing configs between servers, "what changed between two runs",
checking whether two lists agree, or feeding `while read` loops without
creating a subshell: `while read ...; done < <(command)`.

## Going further

Sometimes you want to keep what flows through a pipe as well as pass it on.
That is `tee`, next.
