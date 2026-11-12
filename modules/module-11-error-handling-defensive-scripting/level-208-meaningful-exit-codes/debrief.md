# Debrief: Meaningful Exit Codes

The exit status is the only part of a script's result that every other program
understands: cron, CI pipelines, monitoring agents and other scripts. A status of
just 0 or 1 tells them "ok" or "not ok". Giving each failure type its own number
adds a second sentence: *what kind* of not-ok.

Conventions help. 0 is success; 1 is a general error; 2 commonly means a usage
or argument mistake; 126 and 127 are reserved by the shell for "found but not
executable" and "command not found"; 128+N means "killed by signal N", so 130 is
Ctrl-C. Stay within 0 to 255 (the status is one byte) and pick your own codes in
the free middle, writing them down in the script header or in `readonly` names
rather than as scattered literals.

Notice also the design of the checks: most specific failures first, success line
last. Messages go to stderr for humans, and the code goes through `exit` for
machines. Both channels carry information, and neither should depend on the other
being parsed.

This also changes how callers behave. A wrapper can retry on 5 (service down,
perhaps temporary) and give up immediately on 4 (a broken config will not fix
itself). You will do exactly that two levels from now.

Going further: before inventing codes, prevent the failures. The next level
checks all the inputs before touching anything.
