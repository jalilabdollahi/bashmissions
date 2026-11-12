#!/usr/bin/env bash
# Stream a log through a named pipe: tailfeed writes into feed.pipe in the
# background while this script reads it and shouts about every ERROR line.

# TODO: usage error (stderr, exit 2) when SRC is missing
# TODO: mkfifo feed.pipe
# TODO: tailfeed "$src" feed.pipe &  and keep the PID
# TODO: while IFS= read -r line; do ... done < feed.pipe   (count + print "!! line")
# TODO: print "errors=N"; wait for tailfeed; rm feed.pipe; exit with tailfeed's status
