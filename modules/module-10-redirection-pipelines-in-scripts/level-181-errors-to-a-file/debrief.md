# Debrief: Errors to a File

## What you learned

Every process starts life with a small table of open channels: 0 (stdin),
1 (stdout), 2 (stderr). They are just numbered slots. `>` is shorthand for
`1>`; putting another number in front redirects that slot instead.

## Under the hood

stdout and stderr are different on purpose. A program's results can be piped
into the next program while its complaints still reach a human. The shell
sets up the table before the program starts; the program simply writes to
descriptor 2 when it wants to complain, whatever that slot happens to point at.

On a terminal both slots point at the same screen, which is why the streams
look mixed. In a file redirection, they are really separate.

## In real work

Cron jobs (mail only gets stdout noise if you split correctly), deployment
scripts that keep a warnings file next to the build output, and any tool whose
errors you want to grep later.

## Going further

Sometimes you do want one file that holds everything. The next level shows the
short way to send both streams to the same place.
