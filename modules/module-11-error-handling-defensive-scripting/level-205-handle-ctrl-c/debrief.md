# Debrief: Handle Ctrl-C

A signal is a tiny message the operating system delivers to a process: "someone
pressed Ctrl-C", "please terminate", "your terminal closed". Each signal has a
default action, and for SIGINT it is "die now". `trap handler INT` replaces that
default with your own code, which runs between two commands of the script.

What a good handler does is small: stop starting new work, save what is needed to
resume, tell the human what happened, and exit. The final `exit` is part of the
contract. Without it Bash resumes the script after the handler, and the Ctrl-C
becomes a mere pause.

The status 130 is a convention, 128 plus the signal number (SIGINT is 2).
Parent scripts and shells recognise it as "interrupted by the user", which is
different from "failed". Your own wrapper script can test for it and decide not
to retry.

Remember the limit of the tool: a trap cannot catch SIGKILL (`kill -9`), and a
script blocked in a long foreground command only runs its handler once that
command finishes. Plan the resume data, such as `import.state`, so a hard kill
still leaves something sensible.

Going further: Ctrl-C is the human's signal. Services get a different one from
the system, TERM, and they should react more gently. That is the next level.
