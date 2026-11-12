# Debrief: Build a Pipeline

## What you learned

The pipe `|` connects the stdout of the left command to the stdin of the right
one. The Unix toolbox is built on that: small programs that each do one thing,
combined into answers. Developing a pipeline stage by stage, printing after
every step, is the working method.

## Under the hood

The shell creates a kernel pipe (a small in-memory buffer), starts both
commands at the same time, and wires the left one's descriptor 1 and the right
one's descriptor 0 to the two ends. When the buffer is full the writer waits;
when it is empty the reader waits. Nothing is stored on disk, and the stages
run in parallel, which is why `... | head -n 3` can finish early: the left
side is stopped as soon as the reader goes away.

Each stage is its own process, so each one has its own exit status. By default
only the last matters; `set -o pipefail` changes that, and the next level looks
at the individual statuses.

## In real work

Log analysis, inventory lists, finding big files, counting errors per
service. Any "top N of something" is `sort | uniq -c | sort -rn | head`.

## Going further

If a middle stage fails, which one was it? Next: `PIPESTATUS`.
