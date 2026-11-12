# Debrief: Parallel xargs

## What you learned

`xargs -n 1 -P N command` is a ready-made worker pool: one command per input item,
N at the same time. You trade control for brevity. The things to remember
are the ordering (output arrives in completion order, so sort it) and the
status (123 means "at least one call failed", 255 means "a call was killed or
exited 255 and xargs stopped").

## Under the hood

xargs reads items, forks a child for each batch and keeps a count of running
children. When one exits, it starts the next. That is exactly the counter plus
`wait -n` you wrote by hand. Each child inherits xargs's standard output, so
parallel jobs write to the same stream; short lines are written whole, but long
ones can interleave, so for bigger output use one file per job as in level 314.

A subtle portability point: GNU xargs runs the command once even if there is
no input, while BSD xargs (macOS) runs nothing. The GNU flag `-r` suppresses
that, but macOS lacks it, which is why the level's `thumb` accepts being called
with no name.

## In real work

`find ... | xargs -P 8 ...` compresses logs, converts media, pings hosts and
fetches URLs. Pick N near the number of CPU cores for CPU-bound work and
higher for waiting-bound work such as network calls.

## Going further

`xargs` splits its input on whitespace and quotes. Names with spaces will break
it. The next level fixes that.
