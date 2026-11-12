# Debrief: Append to a File

## What you learned

Opening a file is a decision about the starting position. `>` says "start at
the beginning and throw the rest away". `>>` says "start at the end". The
command writing is identical in both cases; only the shell's `open()` call
changes.

## Under the hood

`>>` uses the append flag (`O_APPEND`). With that flag the kernel moves the
write position to the end of the file at every single write, not just once at
the start. This is why several programs can append to the same log at the same
time and their lines do not overwrite each other (short writes are even
atomic on local disks).

## In real work

Log files, audit trails, CSV rows collected over time, "last 30 results"
files. Almost every file that grows is written with `>>`.

## Going further

So far we only moved normal output. Programs have a second channel for
complaints, and the next level shows how to send errors into a file of their
own.
