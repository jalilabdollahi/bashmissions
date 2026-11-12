# Debrief: Source a Library

`source file` (or `. file`) makes Bash read a file and execute its commands in
the current shell, exactly as if you had pasted them in at that point. Because it
is the same shell, functions, variables and even changes of directory carry over.
That is the key difference from running a script normally, which starts a child
process whose definitions disappear on exit.

This gives scripts the thing every programming language calls a library or
module. One file holds the shared helpers, and every script loads it: one fix, all
scripts updated. Teams commonly keep a `lib/` folder with `log.sh`, `net.sh`
and so on, and each script starts with a few `source` lines.

Practical points. A path without a slash makes Bash search `PATH` for the file, so
use `./lib.sh` or a full path; real scripts compute the folder from the script's own
location. A library should only *define* things, not do work or print, because
sourcing runs every line. And it is polite not to put `exit` in a library: it would
end the caller.

Note the safety side: sourcing a file runs it with all your permissions, so
only source files you trust.

Going further: when two files define the same function name, the later one wins.
Level 115 puts that to practical use.
