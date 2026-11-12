# Debrief: Trace to a File

A process owns a small table of numbered channels called file descriptors:
0 is stdin, 1 is stdout, 2 is stderr. Redirections like `2>file` rearrange that
table. xtrace is hard-wired to descriptor 2 by default, which is why the trace
and your real error messages end up in the same pile.

`BASH_XTRACEFD` changes the destination. Give it a descriptor number and the
trace goes there. Since the number must refer to something open, you first open
a descriptor yourself: `exec 3>trace.log` connects number 3 to a file for the
remainder of the script. Use any free number from 3 upwards; below 3 are taken.
(Bash 4.1 and newer support this. Unsetting `BASH_XTRACEFD` sends the trace
back to stderr and closes the descriptor Bash was using.)

Why bother? Because stderr has jobs. Cron mails it, CI marks a build "noisy"
because of it, wrappers parse it, and humans read it. Mixing a verbose trace
into that stream creates new problems while solving the old one. A separate
trace file can be kept, rotated and attached to a bug report, and the real
errors keep their meaning.

Going further: sometimes you want the trace only when asked. The next level
adds a DEBUG switch that turns diagnostic output on from the environment.
