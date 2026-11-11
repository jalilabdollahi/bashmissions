# Debrief: Named Pipes

## What you learned

A FIFO is a pipe you can `ls`. `mkfifo` creates a special file; one process
opens it for writing, another for reading, and bytes flow from the first to the
second through a small buffer in the kernel. Nothing is stored on disk, no
temporary copy of the data exists, and the reader can start working on the first
line while the writer is still producing the last.

## Under the hood

Opening a FIFO is a rendezvous: `open()` for reading blocks until a writer has
opened it too, and vice versa. That explains the hang in a one-process script
and why the writer is backgrounded. The reader sees end-of-file when every
writer has closed the pipe. A writer that outlives its reader, or tries to
write after the reader has gone, gets SIGPIPE.

The pipe `|` in `a | b` is the same kernel object, created anonymously by the
shell for the two commands it starts. A named pipe just gives that object a
path, so *unrelated* processes can connect.

## In real work

FIFOs feed log shippers, connect a long-running daemon to a command-line
client, and let a script "listen" for messages dropped in by other scripts.
Always remove them when done; they are ordinary directory entries.

## Going further

A script can also receive a nudge without a pipe at all: a signal. Next you will
send one to yourself and catch it.
