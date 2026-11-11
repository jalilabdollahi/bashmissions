# Debrief: Both Streams, One File

## What you learned

You can aim descriptors 1 and 2 at one shared destination. `&>` is Bash's
shorthand for "everything this command says". The result is a single
chronological record, the kind of log a human can actually read.

## Under the hood

`&> file` opens the file once and makes both slots in the process's descriptor
table refer to that same open file. Both descriptors share one write position,
so lines never overwrite each other. If you instead wrote `> log 2> log`, the
file would be opened twice with two independent positions, and the output
would be garbled. Sharing is the point.

## In real work

Build logs, installer transcripts, cron job output: any time you want to
review later what happened, in order, without caring which stream a line came
from.

## Going further

`&>` is a Bash extension. The portable spelling uses a different idea, copying
one descriptor onto another, and the order you write it in matters. That is
next.
