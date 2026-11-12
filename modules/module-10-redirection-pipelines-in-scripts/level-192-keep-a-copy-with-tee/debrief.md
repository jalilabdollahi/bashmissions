# Debrief: Keep a Copy with tee

## What you learned

Redirection sends a stream to one destination; `tee` splits it into two. It
sits in the middle of a pipeline, copies everything that passes, and lets you
observe a pipeline without disturbing it.

## Under the hood

`tee` is an ordinary program that reads stdin and writes each chunk to stdout
and to each file. Nothing special about the shell is involved. That is also why
only stdout flows through it: stderr needs `2>&1` to join the pipe.

Because `tee` is the final stage, it determines the pipeline's status.
`pipefail` makes Bash report the last non-zero status among all stages. In
the previous level you got the full list with `PIPESTATUS`; `pipefail`
is the quick form when you only need "did anything fail".

## In real work

Deploy scripts, installers, support sessions: anywhere a human watches and
the record must survive. Also `... | tee out.txt | grep ...` to save an
intermediate result inside a long pipeline.

## Going further

`tee` copies a stream you already have. Next, taking control of the
numbers themselves: opening your own file descriptors with `exec`.
