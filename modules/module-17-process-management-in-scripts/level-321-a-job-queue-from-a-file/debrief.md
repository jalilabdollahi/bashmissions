# Debrief: A Job Queue from a File

## What you learned

A worker is nothing exotic: it is a loop in a background process. To share a
queue between workers without any locking, **partition** it: worker `i` takes
every job whose number leaves remainder `i`. No two workers can ever pick the
same job, because the rule decides in advance, and no communication is needed.

## Under the hood

Each background worker is a forked copy of your shell with its own copy of
`n`, its own file position in the queue and its own idea of which job is next.
They share only the file system and the output pipe. That is why the final
counts come from the text the workers printed, not from variables they
changed: those changes would be lost when the worker ends (as in the
subshell levels).

`$( { ...; wait; } | sort )` is a small pattern worth memorising: start
everything inside a group, wait inside the group, and sort what came out. The
`wait` keeps the group (and so the pipeline) alive until every worker is done,
which also means the results are complete when the command substitution
returns. Without it the script would race ahead to the report.

The weakness of static splitting is load balance: if every third job is slow,
one worker has all of them.

## In real work

Deploy lists, nightly per-customer reports and bulk imports all fit "a file of
jobs plus N workers". The report-at-the-end shape is what operations people
want to read.

## Going further

For true load balancing the workers must take their next job from a *shared*
supply when they become free. A pipe can hand out permits. That is next.
