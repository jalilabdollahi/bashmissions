# Debrief: Log to File and Screen

A running program has one output stream, but two audiences: a person watching
now, and a person reading later. `tee` is the adapter between them. It reads
its standard input and writes it to standard output *and* to a file, like the
T-shaped pipe fitting it is named after.

The `-a` flag is the whole lesson in two characters. Without it, `tee` opens the
file the same way `>` does and truncates it: yesterday's evidence is gone the
moment tonight's run starts. With `-a` it opens the file for appending, the same
as `>>`. A log is append-only by nature, and every real logging setup,
from syslog to the rotated files in `/var/log`, relies on it.

Checking the folder first is a small piece of defensive scripting: a pipeline
with `tee` could print to the screen happily while the file silently fails, and
you would discover the missing record only when you need it. Fail early and
loudly, with a message that names the path.

Where you meet this: cron jobs that must be watched interactively during
testing, installers that keep `install.log`, deploy scripts whose output ends
up in a ticket.

Going further: logs grow forever. The next level watches a log's size and moves
it aside before it eats the disk.
